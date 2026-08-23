IMAGE_PREFIX ?= localhost
PROJECT_NAME ?= myname

.PHONY: all vulkan rocm rocm-nightly

all: vulkan rocm rocm-nightly

vulkan:
	podman build -t $(IMAGE_PREFIX)/${@}-build:latest -f Containerfile .
	toolbox create --image $(IMAGE_PREFIX)/${@}-build ${@}-build

rocm:
	podman build -t $(IMAGE_PREFIX)/${@}-build:latest -f Containerfile --build-arg EXTRA_PACKAGES="rocm-devel" .
	toolbox create --image $(IMAGE_PREFIX)/${@}-build ${@}-build

rocm-nightly:
	toolbox create --image $(IMAGE_PREFIX)/${<}-build ${@}-build
	toolbox run --container ${@}-build rocm-nightly install amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel
