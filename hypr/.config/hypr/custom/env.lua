hl.env("TERM", "kitty")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- NVIDIA PRIME render offload
hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
hl.env("__NV_PRIME_RENDER_OFFLOAD_PROVIDER", "NVIDIA-G0")
hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
