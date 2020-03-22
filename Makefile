#!/bin/bash -e -o pipefail

.PHONY: all dependencies clean build generate

help:
	@echo Usage:
	@echo ""
	@echo "  make all      - install dependencies and run clean generate build"
	@echo "  make clean    - removes all generated products"
	@echo "  make build    - build the project"
	@echo "  make generate - generates a project with local dependencies"
	@echo ""

all: dependencies clean generate build

dependencies:
	@command -v carthage >/dev/null 2>&1 || { brew >&2 install carthage; }
	@command -v swiftlint >/dev/null 2>&1 || { brew >&2 install swiftlint; }

clean:
	rm -rf build
	rm -rf .swiftpm

generate: 
	rm -rf RxPlayground.xcodeproj
	xcodegen generate --spec project.yml
	cd ..

build:
	carthage update --platform iOS
	xcodebuild build
