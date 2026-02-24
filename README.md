# CachyOS Mac Pro 6,1 Edition

A custom [CachyOS](https://cachyos.org) ISO for the **Mac Pro 6,1 (Late 2013)** with hardware support baked in.

## What You Get

- Full CachyOS desktop (KDE Plasma, 17+ DE options via installer)
- Custom **linux-macpro61** kernel with:
  - AMD D300/D500/D700 GPU firmware embedded (amdgpu driver)
  - Cold-boot protection (Apple EFI needs poweroff, not reboot, for GPU init)
  - Broadcom ethernet ready
  - BORE CPU scheduler
  - BBR3 congestion control
- CachyOS performance optimizations (ananicy-cpp, optimized packages)
- Calamares graphical installer — point and click to install

## Quick Start (Build the ISO)

You need a working Arch Linux or CachyOS installation to build. If your Mac Pro already runs Arch/CachyOS, you can build directly on it.

### Step 1: Install build tools

```bash
sudo pacman -S archiso mkinitcpio-archiso squashfs-tools grub git --needed
```

### Step 2: Clone this repo

```bash
git clone https://github.com/wolffcatskyy/cachyos-macpro-iso.git
cd cachyos-macpro-iso
```

### Step 3: Get the kernel packages

Download the latest `linux-macpro61` packages from [linux-mac releases](https://github.com/wolffcatskyy/linux-mac/releases) and place them in `local-repo/`:

```bash
mkdir -p local-repo
# Download both packages into local-repo/
# linux-macpro61-*.pkg.tar.zst
# linux-macpro61-headers-*.pkg.tar.zst
```

Then create the local package database:

```bash
cd local-repo
repo-add macpro.db.tar.gz *.pkg.tar.zst
cd ..
```

### Step 4: Update the repo path

Edit `archiso/pacman.conf` and change the `[macpro]` section at the bottom to point to your `local-repo` directory:

```ini
[macpro]
SigLevel = Never
Server = file:///full/path/to/cachyos-macpro-iso/local-repo
```

### Step 5: Trust the CachyOS signing key

```bash
sudo pacman-key --recv-keys 882DCFE48E2051D48E2562ABF3B607488DB35A47
sudo pacman-key --lsign-key 882DCFE48E2051D48E2562ABF3B607488DB35A47
```

### Step 6: Build

```bash
sudo ./buildiso.sh -p desktop -v -w
```

The ISO will appear in `out/desktop/`. It will be around 2.5-3 GB.

### Step 7: Write to USB

```bash
sudo dd if=out/desktop/cachyos-macpro-*.iso of=/dev/sdX bs=4M status=progress
sync
```

Replace `/dev/sdX` with your USB drive. **Double-check the device name** — this erases everything on it. Use `lsblk` to identify your USB drive.

### Step 8: Boot your Mac Pro

1. Plug the USB into your Mac Pro
2. Power on (or power off first if already running — **always poweroff, never reboot**)
3. **Hold the Option key** immediately after pressing the power button
4. Select the USB drive from the boot menu
5. Choose **"CachyOS (Mac Pro 6,1)"** from the GRUB menu
6. The desktop will load — double-click the installer icon

## Already Running Arch? (No ISO Needed)

If your Mac Pro already has Arch Linux installed, you don't need the ISO. You can upgrade in-place:

1. Install the [linux-macpro61](https://github.com/wolffcatskyy/linux-mac) kernel package
2. Add the CachyOS repo to `/etc/pacman.conf` (above `[core]`):
   ```ini
   [cachyos]
   Server = https://mirror.cachyos.org/repo/$arch/$repo
   ```
3. Import the key and install CachyOS packages:
   ```bash
   sudo pacman-key --recv-keys 882DCFE48E2051D48E2562ABF3B607488DB35A47
   sudo pacman-key --lsign-key 882DCFE48E2051D48E2562ABF3B607488DB35A47
   sudo pacman -Sy cachyos-keyring cachyos-mirrorlist
   sudo pacman -S cachyos-hooks cachyos-settings cachyos-rate-mirrors
   sudo pacman -Syu
   ```
4. Poweroff and press the power button (never reboot)

Your data, home directory, and everything stays intact.

## Important: Never Reboot

The Mac Pro 6,1 has a quirk with Apple EFI: the GPU firmware only initializes on a **cold boot** (power off then power on). A warm reboot leaves the GPU in an uninitialized state — you get a black screen.

This ISO includes protections:
- `reboot` command is aliased to `poweroff`
- `reboot.target` is masked in systemd
- GRUB menu warns about this

**Always use `sudo poweroff` then press the power button.**

## What's Changed from Stock CachyOS ISO

| File | Change |
|------|--------|
| `archiso/packages_desktop.x86_64` | `linux-cachyos` replaced with `linux-macpro61`, nvidia packages removed |
| `archiso/pacman.conf` | Local repo added for custom kernel |
| `archiso/grub/grub.cfg` | Mac Pro kernel + amdgpu boot params as default |
| `archiso/syslinux/archiso_sys-linux.cfg` | Same for BIOS boot |
| `archiso/profiledef.sh` | ISO name/label updated |
| `archiso/airootfs/etc/modprobe.d/macpro-gpu.conf` | amdgpu SI support, radeon blacklisted |
| `archiso/airootfs/etc/profile.d/no-reboot.sh` | Reboot alias protection |
| `archiso/airootfs/etc/systemd/system/reboot.target` | Masked (symlink to /dev/null) |
| `archiso/airootfs/etc/pacman.d/hooks/99-esp-kernel-sync.hook` | Auto-sync kernel to ESP on update |

## Reporting Issues

Found a bug or need help? [Open an issue](https://github.com/wolffcatskyy/cachyos-macpro-iso/issues).

If you can test the ISO on your Mac Pro 6,1, we'd love to hear your results — especially:
- Which GPU model (D300, D500, or D700)?
- Did the installer work?
- Did the system boot after install?
- Any hardware that didn't work?

## Credits

- [CachyOS](https://cachyos.org) for the base ISO builder and optimized packages
- [linux-mac](https://github.com/wolffcatskyy/linux-mac) project for the Mac Pro 6,1 kernel
