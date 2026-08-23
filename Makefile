IMAGE_PREFIX ?= localhost
PROJECT_NAME ?= myname

# $(1) = image base name
define PODMAN_BUILD
	podman build -t $(IMAGE_PREFIX)/$(1)-build:latest -f Containerfile.$(1) .
endef

# $(1) = container base name, $(2) = image base name
define TOOLBOX_CREATE
	podman container exists $(1)-build || toolbox create --image $(IMAGE_PREFIX)/$(2)-build $(1)-build
endef

.PHONY: all vulkan rocm rocm-nightly update-rocm-nightly

all: vulkan rocm rocm-nightly

vulkan:
	$(call PODMAN_BUILD,$@)
	$(call TOOLBOX_CREATE,$@,$@)

rocm: vulkan
	$(call PODMAN_BUILD,$@)
	$(call TOOLBOX_CREATE,$@,$@)

rocm-nightly:	vulkan
	$(call TOOLBOX_CREATE,$@,$<)
	toolbox run --container ${@}-build ${HOME}/bin/rocm-nightly -y install amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel

update-rocm-nightly:
	toolbox run --container ${@}-build ${HOME}/bin/rocm-nightly -y update amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel
