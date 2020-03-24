.DEFAULT_GOAL := all
.PHONY =: clean compile deploy destroy
.SILENT : clean compile deploy destroy

# Temporary paths for building the artifacts
build_dir=build

all: clean compile deploy

clean:
	rm -rf $(build_dir)

compile: $(build_dir)/playbook.run
	echo "Package build successfully!"

deploy: compile
	cd ops/terraform && terraform-auto \
		--environment-file="../../.env" \
		--backend-template-file="backend.tf-template" \
		apply $(args)

destroy:
	cd ops/terraform && terraform-auto \
		--environment-file="../../.env" \
		--backend-template-file="backend.tf-template" \
		destroy $(args)

$(build_dir):
	mkdir -p $(build_dir)

# Using 'go get' is the farest we can get for a trivial project to have package management.
#
# Go's `dep` project expects all Go code to be inside $GOPATH. That's unmanageable because it forces
# you to structure your code as language-centric instead of project-centric. That's a choice that
# `dep` made out of the Go environment constraints. While this isn't changed, it doesn't make much
# sense for small projects such as this one to use a package manager, unfortunately.
#
# See: https://github.com/golang/dep/issues/148#issuecomment-337942928
$(build_dir)/players-count: $(build_dir)
	go get github.com/rumblefrog/go-a2s
	GOOS=linux GOARCH=amd64 \
		go build -o $(build_dir)/players-count app/lib/player-counter/main.go

$(build_dir)/vars.yml: $(build_dir)
	cp ops/ansible/vars.yml $(build_dir)
	sh -c 'source ./.env; sed -i"" "s/%GSLT_TOKEN%/$$GSLT_TOKEN/" $(build_dir)/vars.yml'

$(build_dir)/playbook.run: $(build_dir)/players-count $(build_dir)/vars.yml
	~/Projects/ansible-bundler/app/bin/bundle-playbook -f ops/ansible/server.yml \
		-r ops/ansible/requirements.yml -v $(build_dir)/vars.yml \
		-d ops/ansible/files -d $(build_dir)/players-count \
		-o $(build_dir)/playbook.run
