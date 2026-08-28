# Pandoras Boxes

Fedora-based container toolboxes for self-hosting LLMs on AMD & Intel hardware.

## Hardware

- AMD Strix Halo
  - 16-core AMD RYZEN AI MAX+ 395 w/ Radeon 8060S
- Intel Arc graphics

## Runtimes

| Runtime   | Vulkan        | ROCm    | OpenVino | Notes                             |
|-----------|---------------|---------|----------|-----------------------------------|
| llama.cpp | Secondary     | Primary | -        | Best Vulkan support via ggml      |
| DS4       | When possible | Primary | -        | GPU backend dependent             |
| vLLM      | N/A           | Primary | -        | ROCm-only for AMD; no Vulkan path |


## Quick start

- Build a specific toolbox
  ```bash
  make <vulkan|rocm|rocm-nightly>
  ```
- Update ROCm nightly:
  ```bash
  make update-rocm-nightly
  ```
