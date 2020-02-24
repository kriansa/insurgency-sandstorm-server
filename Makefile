.PHONY =: clean build
.DEFAULT_GOAL := build
.SILENT : clean build deploy destroy

# Temporary paths for building the artifacts
build_dir=build

clean:
	rm -rf $(build_dir)
	( cd app/lib/player-counter && make clean )

deploy: build
	cd ops/terraform && terraform-auto \
		--environment-file="../../.env" \
		--backend-template-file="backend.tf-template" \
		apply $(args)

destroy:
	cd ops/terraform && terraform-auto \
		--environment-file="../../.env" \
		--backend-template-file="backend.tf-template" \
		destroy $(args)

build:
	test -d $(build_dir) || mkdir -p $(build_dir)
	( cd app/lib/player-counter && GOOS=linux GOARCH=amd64 make build )

	# Copy the vars.yml to a temp directory and make compile-time replacements
	cp ops/ansible/vars.yml $(build_dir)
	sh -c 'source ./.env; sed -i"" "s/%GSLT_TOKEN%/$$GSLT_TOKEN/" $(build_dir)/vars.yml'

	# Builds the playbook
	~/Projects/ansible-bundler/app/bin/bundle-playbook -f ops/ansible/server.yml -r ops/ansible/requirements.yml \
		-v $(build_dir)/vars.yml -d ops/ansible/templates -d ops/ansible/files \
		-o $(build_dir)/playbook.run

	# Now remove the temp 'vars.yml'
	rm -f $(build_dir)/vars.yml

	echo "Package build successfully!"
