IMAGE_TAG ?= github-action-runner:test
RUNNER_VERSION ?= 2.328.0
UBUNTU_VERSION ?= 22.04

.PHONY: test test-shellcheck test-bats test-docker docker-build

test: test-shellcheck test-bats test-docker

test-shellcheck:
	shellcheck start.sh

test-bats:
	bats tests/start.bats

docker-build:
	docker build \
		--build-arg RUNNER_VERSION=$(RUNNER_VERSION) \
		--build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) \
		-t $(IMAGE_TAG) .

test-docker: docker-build
	./tests/docker-test.sh $(IMAGE_TAG)
