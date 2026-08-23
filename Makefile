IMAGE_PREFIX ?= localhost
PROJECT_NAME ?= myname

# $(1) = container base name, $(2) = image base name
define TOOLBOX_CREATE
	podman container exists $(1)-build || toolbox create --image $(IMAGE_PREFIX)/$(2)-build $(1)-build
endef

.PHONY: all vulkan rocm rocm-nightly

all: vulkan rocm rocm-nightly

vulkan:
	podman build -t $(IMAGE_PREFIX)/${@}-build:latest -f Containerfile.vulkan .
	$(call TOOLBOX_CREATE,$@,$@)

rocm: vulkan
	podman build -t $(IMAGE_PREFIX)/${@}-build:latest -f Containerfile.rocm .
	$(call TOOLBOX_CREATE,$@,$@)

rocm-nightly:	vulkan
	$(call TOOLBOX_CREATE,$@,$<)
	toolbox run --container ${@}-build ${HOME}/bin/rocm-nightly install amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel

update-rocm-nightly:
	toolbox run --container ${@}-build ${HOME}/bin/rocm-nightly update amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel
