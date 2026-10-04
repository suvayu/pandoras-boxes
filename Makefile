IMAGE_PREFIX  ?= localhost
ROCM_PACKAGES := amdrocm{,-core-sdk}????-gfx1151 rocwmma-devel

# common container options
dev  := --device /dev/dri
grps := --group-add video --group-add render --group-add sudo
sec  := --security-opt seccomp=unconfined

# GH token for lemonade-server
gh_tok := $(shell gh auth token 2>/dev/null || true)
ifeq ($(gh_tok),)
	$(error "gh: not authenticated, please login")
endif
secmnt := --secret id=GITHUB_TOKEN,env=GITHUB_TOKEN

# backend specific options
vulkan_opts   := $(dev) $(grps) $(sec)
rocm_opts     := $(dev) --device /dev/kfd $(grps) $(sec)
openvino_opts := $(dev) $(grps) $(sec) --env=GGML_OPENVINO_DEVICE=GPU --env=GGML_OPENVINO_STATEFUL_EXECUTION=1

# $(1) = image base name
define PODMAN_BUILD
	GITHUB_TOKEN=$(gh_tok) podman build $(secmnt) -t $(IMAGE_PREFIX)/build-$(1):latest -f Containerfile.$(1) .
endef

# $(1) = container base name, $(2) = image base name, $(3) = options
define TOOLBOX_CREATE
	podman container exists build-$(1) || toolbox create --image $(IMAGE_PREFIX)/build-$(2) build-$(1) -- $(3)
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
	$(call TOOLBOX_CREATE,$@,$@,$($@_opts))

rocm openvino oneapi:%:	vulkan
	$(call PODMAN_BUILD,$@)
	$(call TOOLBOX_CREATE,$@,$@,$($@_opts))

rocm-nightly:	vulkan
	$(call TOOLBOX_CREATE,$@,$<)
	$(call TOOLBOX_RUN,$@,${HOME}/bin/rocm-nightly -y install $(ROCM_PACKAGES))

update-rocm-nightly:
	$(call TOOLBOX_RUN,rocm-nightly,./rocm-nightly -y upgrade $(ROCM_PACKAGES))
