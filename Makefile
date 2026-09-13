IMAGE_PREFIX ?= localhost
PROJECT_NAME ?= myname
ROCM_PACKAGES := amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel

# $(1) = image base name
define PODMAN_BUILD
	podman build -t $(IMAGE_PREFIX)/build-$(1):latest -f Containerfile.$(1) .
endef

# $(1) = container base name, $(2) = image base name
define TOOLBOX_CREATE
	podman container exists build-$(1) || toolbox create --image $(IMAGE_PREFIX)/build-$(2) build-$(1)
endef

# $(1) = container base name, $(2) = command to run
define TOOLBOX_RUN
	toolbox run --container build-$(1) $(2)
	podman stop build-$(1)
endef

.PHONY: all vulkan rocm rocm-nightly update-rocm-nightly

all: vulkan rocm rocm-nightly

vulkan:
	$(call PODMAN_BUILD,$@)
	$(call TOOLBOX_CREATE,$@,$@)

rocm openvino:%:	vulkan
	$(call PODMAN_BUILD,$@)
	$(call TOOLBOX_CREATE,$@,$@)

rocm-nightly:	vulkan
	$(call TOOLBOX_CREATE,$@,$<)
	$(call TOOLBOX_RUN,$@,${HOME}/bin/rocm-nightly -y install $(ROCM_PACKAGES))

update-rocm-nightly:
	$(call TOOLBOX_RUN,rocm-nightly,./rocm-nightly -y upgrade $(ROCM_PACKAGES))
