# Pandoras Boxes

Fedora-based container toolboxes for self-hosting LLMs on AMD & Intel hardware.

## Hardware

- AMD Strix Halo
  - 16-core AMD RYZEN AI MAX+ 395 w/ Radeon 8060S
- Intel Arc graphics

## Runtimes

| Runtime   | Vulkan        | ROCm    | oneAPI  | Notes                                         |
|-----------|---------------|---------|---------|-----------------------------------------------|
| llama.cpp | secondary     | primary | primary | Best Vulkan support via ggml                  |
| DS4       | when possible | primary | -       | GPU backend dependent                         |
| Gufo      | -             | primary | -       |                                               |
| Strata    | -             | maybe   | primary | Prefer for small VRAM; needs large system RAM |
| ~vLLM~    | n/a           | primary | -       | ROCm-only for AMD; no Vulkan path             |


## Quick start

- Build a specific toolbox
  ```bash
  make <runtime>
  ```
- Update ROCm nightly:
  ```bash
  make update-rocm-nightly
  ```
