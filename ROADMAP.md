# Roadmap

_Refreshed September 24, 2026. Plans, not promises: priorities can shift with user feedback._

- Next: publish a corrected ISO release resolving the v2026.02.23 install blockers from [#1](https://github.com/wolffcatskyy/cachyos-macpro-iso/issues/1) — the Calamares installer honoring the bundled linux-macpro61 kernel and Mesa packages, applesmc fan control during installation, and SSH available out of the box.
- Then: refresh the bundled kernel and Mesa from current [linux-mac](https://github.com/wolffcatskyy/linux-mac) releases, resync with upstream CachyOS ISO changes, and automate ISO builds with published checksums.
- Later: a community-tested hardware matrix across D300, D500, and D700 configurations, and broader legacy Mac support once the Mac Pro 6,1 build is proven.

## Current State

**Latest release:** [v2026.02.23](https://github.com/wolffcatskyy/cachyos-macpro-iso/releases) (February 2026) — flagged **do not install** pending the fixes above (see [#1](https://github.com/wolffcatskyy/cachyos-macpro-iso/issues/1)).
**GitHub stars:** 5

- Custom linux-macpro61 kernel with AMD FirePro D300/D500/D700 firmware baked in (amdgpu driver)
- Cold-boot protection: reboot aliased to poweroff, reboot.target masked, GRUB warnings
- BORE CPU scheduler and BBR3 congestion control
- Calamares graphical installer with 17+ desktop environment options
- ESP kernel-sync pacman hook so kernel updates reach the boot partition

## Contributing

Testing reports are the most valuable contribution right now — which GPU model (D300, D500, or D700), whether the installer completed, and whether the system booted after install. Share results in [Issues](https://github.com/wolffcatskyy/cachyos-macpro-iso/issues).

Feedback and feature requests: open an issue.
