hl.env("TERM", "kitty")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- NVIDIA PRIME render offload is applied per-application via `prime-run`.
-- Setting it session-wide puts every Wayland client on the dGPU while the
-- compositor composites on the iGPU, which breaks cross-GPU dmabuf imports.
