IMAGE_PREFIX ?= localhost
PROJECT_NAME ?= myname

.PHONY: all vulkan rocm rocm-nightly

all: vulkan rocm rocm-nightly

vulkan:
	podman build -t $(IMAGE_PREFIX)/${@}-build:latest -f Containerfile.vulkan .
	toolbox create --image $(IMAGE_PREFIX)/${@}-build ${@}-build

rocm: vulkan
	podman build -t $(IMAGE_PREFIX)/${@}-build:latest -f Containerfile.rocm .
	toolbox create --image $(IMAGE_PREFIX)/${@}-build ${@}-build

rocm-nightly:	vulkan
	toolbox create --image $(IMAGE_PREFIX)/${<}-build ${@}-build
	toolbox run --container ${@}-build ${HOME}/bin/rocm-nightly install amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel

update-rocm-nightly:
	toolbox run --container ${@}-build ${HOME}/bin/rocm-nightly update amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel
