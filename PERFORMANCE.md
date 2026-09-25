# MacPro6,1 64 GiB performance candidate (UNTESTED)

- Fans: firmware-reported maximum, regardless of noise and power cost. Requested by owner; confirm SMC write and actual RPM on hardware. Persistent service needs installation and verification.
- Memory: 8 GiB capped zram (`min(ram/8,8192)` MiB), zstd, high swap priority. This is an OOM safety net and consumes CPU/RAM when active. Check `swapon --show`, `zramctl`, pressure metrics, and workload performance after installation. Source: https://man.archlinux.org/man/extra/zram-generator/zram-generator.conf.5.en
- Swappiness 20 and VFS cache pressure 50: favor resident workloads while retaining useful compressed swap. Not a universal gain; compare with defaults on this workload.
- Dirty data: cap background writeback at 128 MiB and foreground dirty bytes at 512 MiB; avoids 64 GiB-percent-based multi-GiB flushing stalls, but may reduce sequential write throughput.
- CPU governor: keep the kernel's default (typically schedutil if supported). Forcing `performance` on 2013 hardware raises idle heat/power and needs measurement; do not flip it blindly.
- I/O scheduler: keep the kernel/device default until storage devices and benchmarks are known. NVMe and SATA workloads differ; a global udev override can hurt one of them.
- CPU security mitigations: unchanged, never disable by default. Any opt-in tradeoff needs a separate owner decision and a measurement plan.
- Existing linux-mac sysctl source enables `kvm.ignore_msrs=1`, BBR, TCP Fast Open and high dirty percentages. Audit those separately. They are not added as a blanket performance preset here.

This tune is not evidence the kernel, installer, or ISO works. Test with a no-AVX2 CPU and physical Mac Pro before release.
