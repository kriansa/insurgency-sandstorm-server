.PHONY =: build deps
.DEFAULT_GOAL := build

# This is as far as we can get for a trivial project to have package management.
#
# Go's `dep` project expects all Go code to be inside $GOPATH. That's unmanageable because it forces
# you to structure your code as language-centric instead of project-centric. That's a choice that
# `dep` made out of the Go environment constraints. While this isn't changed, it doesn't make much
# sense for small projects such as this one to use a package manager, unfortunately.
#
# See: https://github.com/golang/dep/issues/148#issuecomment-337942928
deps:
	go get github.com/rumblefrog/go-a2s

clean:
	rm -rf build

build: deps
	mkdir build
	go build -o build/players-count src/main.go 
