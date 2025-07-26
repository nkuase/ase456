# Makefile for FooBar IndexedDB Application

.PHONY: help install dev build test clean serve

help:
	@echo "Available commands:"
	@echo "  make install  - Install dependencies"
	@echo "  make dev      - Run development server with hot reload"
	@echo "  make build    - Build for production"
	@echo "  make test     - Run tests"
	@echo "  make serve    - Serve production build"
	@echo "  make clean    - Clean build artifacts"

install:
	dart pub get

dev:
	dart run build_runner serve web:8080

build:
	dart run build_runner build --release -o web:build

test:
	dart test

serve: build
	@echo "Serving production build at http://localhost:8000"
	cd build && python3 -m http.server 8000

clean:
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf .packages
