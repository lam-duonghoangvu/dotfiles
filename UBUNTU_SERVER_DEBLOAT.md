# Ubuntu Server Debloat Guide

A guide to slimming down an Ubuntu Server 26.04 install used as a **headless home server**:

- **Services** run in Docker. **Dev toolchains** come from mise. **Remote access** is Tailscale and SSH.
- **Networking** is NetworkManager (an ethernet uplink plus a Wi-Fi hotspot). netplan stays only as the config frontend.
- **Hardware it was written for:** an AMD Ryzen APU (Radeon Vega iGPU), Realtek ethernet, an Intel AX200 Wi-Fi/Bluetooth card and a single NVMe with ext4. It's bare metal, and dracut builds the initramfs.

**Scope:** only remove bloat that **Ubuntu itself** installs. Leave alone extras that third-party installs bring in (for example `docker-ce-rootless-extras` from Docker's repo).

**General rules:**

- Preview first: `apt purge --dry-run …` / `apt-get -s …`, and read the REMOVING list before confirming.
- Do networking changes from a local console, not over SSH.
- Reboot after kernel, firmware or boot-related changes, and check the system before going on.

---

## 1. Remove old kernel

Ubuntu keeps the previous kernel as a boot fallback. Once the current kernel has booted reliably, remove the old one (image, modules, headers, tools).

### Check

```bash
uname -r                                              # running kernel. NEVER remove this one
dpkg -l 'linux-image-[0-9]*' | awk '/^ii/{print $2}'  # installed kernel images
```

If more than one version is listed, inspect every package belonging to the old one (replace `OLD`, e.g. `7\.0\.0-34`):

```bash
dpkg -l | awk '/^ii/ && /OLD/{print $2}'
```

### Remove

```bash
sudo apt purge $(dpkg -l | awk '/^ii/ && /OLD/{print $2}')
```

Keep the `linux-generic` metapackage so new kernels still arrive through updates. GRUB and the initramfs are refreshed automatically.

### Rollback

```bash
sudo apt install linux-image-<ver>-generic linux-modules-<ver>-generic \
  linux-main-modules-zfs-<ver>-generic           # only while still in the archive
```

If a new kernel fails to boot, choose _Advanced options_ in GRUB and pick an older kernel. That's why you should only purge old kernels after the new one has proven itself.

---

## 2. Purge residual configs

Packages in state `rc` have been removed, but their config files remain. Purging them only deletes those configs. Run this after any removal that wasn't a purge.

```bash
dpkg -l | awk '/^rc/{print $2}'                       # list
sudo apt purge $(dpkg -l | awk '/^rc/{print $2}')     # purge
```

### Rollback

Nothing to roll back. Reinstalling a package recreates its default config.

---

## 3. Protect core packages

Removing the bloat in section 4 also removes Ubuntu's metapackages (`ubuntu-minimal`, `ubuntu-server`, `ubuntu-server-minimal`). Those metapackages are what keep core tools marked as needed. Without them, a later `apt autoremove` could delete `sudo`, `netplan.io`, `iproute2` and others. Do this **before** section 4:

```bash
sudo apt-mark manual $(apt-cache depends ubuntu-minimal ubuntu-server-minimal \
  | awk '/Depends:/{print $2}' | grep -v '^<' | sort -u)
```

Check: `apt-mark showmanual | grep -xE 'sudo|netplan.io|iproute2|apt|systemd'` should list all five.

### Rollback

```bash
sudo apt install ubuntu-minimal ubuntu-server-minimal ubuntu-server
sudo apt-mark auto $(apt-cache depends ubuntu-minimal ubuntu-server-minimal \
  | awk '/Depends:/{print $2}' | grep -v '^<' | sort -u)
```

---

## 4. Purge bloated packages

### 4.1 Commands

```bash
# Ubuntu bloat
sudo apt purge snapd cloud-init cloud-init-base 'cloud-initramfs-*' \
  multipath-tools open-iscsi lvm2 mdadm cryptsetup btrfs-progs xfsprogs \
  modemmanager apport apport-symptoms python3-apport ubuntu-pro-client \
  landscape-common motd-news-config packagekit fwupd udisks2 upower \
  lxd-installer lxd-agent-loader sos ubuntu-kernel-accessories \
  plymouth plymouth-theme-ubuntu-text telnet inetutils-telnet \
  aptitude open-vm-tools hwctl kdump-tools kexec-tools makedumpfile linux-tools-common
sudo apt autoremove --purge
sudo update-grub                     # drops the crashkernel= boot parameter left by kdump

# leftover directories dpkg can't remove (they hold runtime files)
sudo rm -rf /etc/cloud /var/lib/update-manager /var/lib/xfsprogs
sudo rm -rf /snap /var/snap /var/lib/snapd ~/snap
```

**Before running:**

- **Only on dracut systems** (`dpkg -l dracut` shows `ii`): autoremove also takes `initramfs-tools-core`, `busybox-initramfs` and `klibc-utils`, which only kdump needed. If your system builds the initramfs with `initramfs-tools`, check the dry run carefully.
- **Don't add `ftp` or `tnftp`:** `ubuntu-standard` requires some ftp client, so apt would just install `ftp-ssl` in their place.
- **Don't add `pinentry-gnome3`:** it keeps the GTK and Mesa OpenGL/EGL libraries installed. Removing it would autoremove the Mesa GL drivers of the GPU stack (section 6.1).

### 4.2 What each package does and why it goes

| Package(s)                                                   | What it does                                                     | Why remove it                                                             |
| ------------------------------------------------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `snapd`                                                      | Snap package daemon                                              | Apps come from Docker, tools from mise. No snaps needed.                  |
| `cloud-init*`, `cloud-initramfs-*`                           | Configures cloud VMs on first boot (users, SSH keys, network)    | Bare metal. Only useful on cloud images.                                  |
| `multipath-tools`, `open-iscsi`                              | Multipath SAN and iSCSI network storage                          | A single local disk. `multipathd` otherwise runs for nothing.             |
| `lvm2`, `mdadm`, `cryptsetup`                                | LVM volumes, software RAID, LUKS encryption                      | Plain ext4 partition. **Keep the ones you actually use.**                 |
| `btrfs-progs`, `xfsprogs`                                    | btrfs / XFS filesystem tools                                     | Root is ext4.                                                             |
| `modemmanager`                                               | Manages cellular (3G/4G/5G) modems                               | No modem.                                                                 |
| `apport*`, `python3-apport`                                  | Collects crash reports for Ubuntu                                | Not useful on a personal server.                                          |
| `ubuntu-pro-client*`, `landscape-common`, `motd-news-config` | Ubuntu Pro subscription, Landscape management, MOTD news and ads | Not subscribed. Cleaner login.                                            |
| `packagekit`                                                 | D-Bus package backend for GUI software centers                   | `apt` is used directly.                                                   |
| `fwupd`                                                      | Firmware/BIOS updates from LVFS                                  | Rarely needed. Reinstall temporarily for a BIOS update.                   |
| `udisks2`, `upower`                                          | Desktop disk automount and battery reporting                     | Headless, no battery.                                                     |
| `lxd-installer`, `lxd-agent-loader`                          | Stub that installs the LXD snap; agent for LXD VMs               | Docker is used, not LXD.                                                  |
| `sos`                                                        | Generates support reports for Canonical/Red Hat                  | Pulls in the large AWS SDK (`python3-boto3`, `botocore`).                 |
| `ubuntu-kernel-accessories`                                  | Kernel tracing tools (`bpftrace`, `bpfcc-tools`, `linux-perf`)   | Kernel debugging only. Pulls in `libclang`.                               |
| `plymouth*`                                                  | Graphical boot splash                                            | Headless.                                                                 |
| `telnet`, `inetutils-telnet`                                 | Legacy unencrypted remote-shell client                           | Obsolete. Use `ssh` or `nc`.                                              |
| `aptitude`                                                   | Alternative ncurses package manager                              | Duplicates `apt`.                                                         |
| `open-vm-tools`                                              | Guest agent for VMware VMs                                       | Bare metal (`systemd-detect-virt` → `none`).                              |
| `hwctl`                                                      | Checks Ubuntu hardware-certification status                      | Only for certification and OEM work.                                      |
| `kdump-tools`, `kexec-tools`, `makedumpfile`                 | Captures a kernel crash dump on panic                            | Permanently reserves RAM (`crashkernel=`) for dumps you'll never analyse. |
| `linux-tools-common` (+ `linux-tools-<ver>*`)                | `perf`, `turbostat`, `cpupower` and other kernel profiling tools | Kernel profiling only.                                                    |

**Removed along with them:** the metapackages `ubuntu-minimal`, `ubuntu-server` and `ubuntu-server-minimal` (see section 3). Also `software-properties-common` (`add-apt-repository`; third-party repos can use plain source files) and `update-manager-core`/`update-notifier-common` (the "N updates available" MOTD line). `do-release-upgrade` and `unattended-upgrades` stay. Autoremove then cleans up the orphaned Perl and Python libraries, the bpf/LLVM tracing stack, `libblockdev*`, the modem libraries, the iPhone helpers (`usbmuxd`), and small tools like `jq` and `gdisk`. Reinstall those two if you use them.

### 4.3 Firmware: keep only what the hardware needs

`linux-firmware` is a metapackage that **depends** on firmware for every device Linux supports. `linux-image-generic` in turn depends on `linux-firmware`, so purging one firmware sub-package on its own also removes `linux-firmware` and **breaks kernel updates**.

Use Ubuntu's `linux-firmware-minimal` instead. It _provides_ `linux-firmware`, so the kernel dependency stays satisfied, and it only _recommends_ the sub-packages. Swap it in and remove the unneeded firmware in one transaction (a trailing `-` means remove). apt never autoremoves recommended packages, so the firmware you keep stays installed without any `apt-mark`:

```bash
sudo apt install --purge --auto-remove --no-install-recommends linux-firmware-minimal \
  linux-firmware-nvidia-graphics- linux-firmware-intel-graphics- \
  linux-firmware-qualcomm-misc- linux-firmware-qualcomm-wireless- linux-firmware-qualcomm-graphics- \
  linux-firmware-mellanox-spectrum- linux-firmware-marvell-prestera- linux-firmware-marvell-wireless- \
  linux-firmware-mediatek- linux-firmware-netronome- linux-firmware-qlogic- \
  linux-firmware-broadcom-wireless- firmware-sof-signed-
```

In the preview, `linux-firmware` is removed (replaced by `-minimal`). `[linux-image-generic]` in brackets is fine: it only means the dependency is now satisfied by `linux-firmware-minimal`. **Abort if `linux-image-generic` itself is in the REMOVING list.**

What's kept for this hardware:

| Package                         | Needed for                                      |
| ------------------------------- | ----------------------------------------------- |
| `linux-firmware-amd-graphics`   | Radeon iGPU (`amdgpu`), also for Vulkan/LLM     |
| `linux-firmware-amd-misc`       | Other AMD platform firmware                     |
| `linux-firmware-intel-wireless` | AX200 Wi-Fi (`iwlwifi`), needed for the hotspot |
| `linux-firmware-intel-misc`     | AX200 Bluetooth and other Intel firmware        |
| `linux-firmware-realtek`        | Realtek ethernet (`r8169`)                      |
| `linux-firmware-misc`           | Generic catch-all                               |

`firmware-sof-signed` (the audio DSP) is removed because the server doesn't use audio. To pick the right set for different hardware, check `lspci -nn` and `journalctl -k -b | grep -i firmware`.

After the reboot, check: `journalctl -k -b | grep -iE 'failed to load|direct firmware load'` should print nothing.

### Rollback

```bash
# any of the removed packages
sudo apt install snapd cloud-init multipath-tools open-iscsi lvm2 mdadm cryptsetup \
  btrfs-progs xfsprogs modemmanager apport ubuntu-pro-client landscape-common \
  packagekit fwupd udisks2 upower plymouth software-properties-common \
  aptitude open-vm-tools linux-tools-generic jq gdisk
sudo apt install kdump-tools && sudo update-grub      # crash dumps: needs a reboot
# all firmware back (replaces linux-firmware-minimal)
sudo apt install linux-firmware
```

---

## 5. NetworkManager setup and disabling networkd

Ubuntu Server defaults to **systemd-networkd**. Installing NetworkManager next to it leaves both running, and `systemd-networkd-wait-online` then times out (about 2 minutes) on every boot. The setup below keeps netplan as the frontend (Ubuntu's base packages depend on `netplan.io`), makes netplan generate **NetworkManager** profiles only, and turns networkd off.

### 5.1 Install

```bash
sudo apt install network-manager wpasupplicant iw wireless-regdb
```

### 5.2 NetworkManager config

`/etc/NetworkManager/NetworkManager.conf`:

```ini
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no
```

These package defaults stay as they are:

- `/etc/NetworkManager/conf.d/default-wifi-powersave-on.conf`: `[connection] wifi.powersave = 3`
- `/usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf`: on its own, this would leave ethernet unmanaged. When netplan's renderer is NetworkManager, netplan overrides it with an empty `/run/NetworkManager/conf.d/10-globally-managed-devices.conf`, so NM manages every device.

### 5.3 Ethernet uplink (netplan)

`/etc/netplan/00-installer-config.yaml`:

```yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp4s0:
      dhcp4: true
```

```bash
sudo chmod 600 /etc/netplan/*.yaml
sudo netplan generate && sudo netplan apply
```

This becomes the NM connection `netplan-enp4s0` (DHCPv4, IPv6 ignored).

### 5.4 Wi-Fi hotspot

This creates a 5 GHz access point (channel 149) with WPA2-PSK, using `ipv4.method shared` (NetworkManager runs DHCP for clients and NATs them out through the uplink). IPv6 is off and it starts automatically at boot.

```bash
sudo nmcli con add type wifi ifname wlp5s0 con-name Hotspot ssid wiifii \
  802-11-wireless.mode ap 802-11-wireless.band a 802-11-wireless.channel 149 \
  wifi-sec.key-mgmt wpa-psk wifi-sec.proto rsn wifi-sec.pairwise ccmp wifi-sec.group ccmp \
  wifi-sec.pmf disable wifi-sec.psk '<PASSWORD>' \
  ipv4.method shared ipv6.method ignore connection.autoconnect yes
sudo nmcli con up Hotspot
```

On Ubuntu, `nmcli` stores this profile as `/etc/netplan/90-NM-<uuid>.yaml`, so it survives reboots and `netplan apply`.

**Make sure `connection.autoconnect` is `yes`.** Otherwise the hotspot stays down after every NetworkManager restart or reboot. Fix an existing profile with `sudo nmcli con modify Hotspot connection.autoconnect yes`.

### 5.5 Disable systemd-networkd

```bash
sudo systemctl disable --now systemd-networkd.service systemd-networkd.socket \
  systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd.service systemd-networkd.socket \
  systemd-networkd-resolve-hook.socket systemd-networkd-varlink.socket \
  systemd-networkd-wait-online.service
sudo apt purge networkd-dispatcher
sudo systemctl reset-failed
```

Mask the units, don't just disable them: the `resolve-hook` and `varlink` sockets can otherwise start networkd again on demand. `systemd-resolved` keeps handling DNS, and NetworkManager passes it the DNS servers from DHCP.

### 5.6 Verify

```bash
nmcli dev                                  # enp4s0 → netplan-enp4s0, wlp5s0 → Hotspot, both "connected"
resolvectl status                          # DNS servers listed on enp4s0
systemctl is-enabled systemd-networkd      # masked
systemd-analyze                            # no 2-minute wait-online delay
```

### Rollback

```bash
sudo systemctl unmask systemd-networkd.service systemd-networkd.socket \
  systemd-networkd-resolve-hook.socket systemd-networkd-varlink.socket \
  systemd-networkd-wait-online.service
sudo systemctl enable --now systemd-networkd systemd-networkd-wait-online
sudo apt install networkd-dispatcher
# to hand interfaces back to networkd: set "renderer: networkd" in 00-installer-config.yaml
sudo netplan apply
```

---

## 6. Other manually installed packages

These are the packages in `apt-mark showmanual` beyond the core set from section 3, and what to do with them.

| Package(s)                                                                                     | What                                               | Keep?                                                                                                     |
| ---------------------------------------------------------------------------------------------- | -------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin` | Docker engine (Docker's repo)                      | Yes, the main workload                                                                                    |
| `tailscale`, `tailscale-archive-keyring`                                                       | Mesh VPN for remote access                         | Yes                                                                                                       |
| `network-manager`, `wpasupplicant`, `iw`                                                       | Networking and hotspot (section 5)                 | Yes                                                                                                       |
| `openssh-server`                                                                               | SSH, started on demand through `ssh.socket`        | Yes                                                                                                       |
| `iptables`, `iptables-persistent`                                                              | Firewall rules restored at boot                    | Yes. Don't run `netfilter-persistent save` while Docker is running, or Docker's own chains get saved too. |
| `zsh`, `tmux`, `htop`, `vim`, `git`, `curl`, `unzip`, `patch`, `make`                          | Shell and everyday tools                           | Yes                                                                                                       |
| `needrestart`                                                                                  | Lists services to restart after library updates    | Yes                                                                                                       |
| `nvme-cli`, `efibootmgr`, `grub-*`, `shim-signed`, `linux-generic`                             | Disk health, UEFI boot, kernel                     | Yes                                                                                                       |
| `gnupg`, `rsyslog`, `chrony`, `fonts-ubuntu-console`                                           | Repo keys, logging, time sync, console font        | Yes                                                                                                       |
| `ubuntu-standard`                                                                              | Remaining Ubuntu metapackage (man, rsync, lsof, …) | Yes, it also stops `ftp-ssl` from being installed                                                         |

### 6.1 GPU / Vulkan stack: kept for local LLMs

| Package                                           | Role                                                                                              |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `mesa-vulkan-drivers`                             | RADV, the Vulkan driver for the Radeon iGPU (uses `libllvm21`)                                    |
| `libvulkan1`                                      | Vulkan loader                                                                                     |
| `libvulkan-dev`                                   | Headers for building Vulkan apps (e.g. llama.cpp with `-DGGML_VULKAN=ON`)                         |
| `vulkan-tools`                                    | `vulkaninfo`, to check that the GPU is visible                                                    |
| `libgl1-mesa-dri`, `libegl-mesa0`, `libglx-mesa0` | Mesa OpenGL/EGL drivers. Kept installed by `pinentry-gnome3`'s dependencies; see the note in 4.1. |

**Why keep it:** to run local LLMs on the APU through the **Vulkan backend** (llama.cpp, Ollama Vulkan builds, LM Studio). ROCm doesn't support these consumer iGPUs, so Vulkan is the practical way to use them. Keep it installed even when it isn't in use.

**Install from scratch:**

```bash
sudo apt install mesa-vulkan-drivers libvulkan1 libvulkan-dev vulkan-tools
sudo usermod -aG render,video "$USER"     # GPU access without root (log in again afterwards)
vulkaninfo --summary                       # should list "AMD Radeon Graphics (RADV …)"
```

**For containers:** pass the device through with `--device /dev/dri` (compose: `devices: ["/dev/dri:/dev/dri"]`) and add the `render` and `video` groups (`group_add`).

**Remove:**

```bash
sudo apt purge mesa-vulkan-drivers libvulkan-dev vulkan-tools && sudo apt autoremove --purge
```

### 6.2 Headless-browser libraries

`libgtk-3-0t64`, `libnss3`, `libgbm1` and `libasound2t64` are the usual system dependencies for Chromium, Playwright, Puppeteer or Electron running **on the host**. Keep them if any of those run outside Docker. Otherwise:

```bash
sudo apt-mark auto libgtk-3-0t64 libnss3 libgbm1 libasound2t64 && sudo apt autoremove --purge
```

### 6.3 System Python and compiler

- **`build-essential`:** mise compiles some tools from source (e.g. Python via python-build, Ruby), and that needs a C toolchain. Keep it.
- **`python3-pip`, `python3-venv`:** only needed for projects that use the system Python. If nothing does:

```bash
sudo apt purge python3-pip python3-venv && sudo apt autoremove --purge
```

### Rollback

`sudo apt install <package>` for anything removed in this section.

---

## 7. Misc cleanup

| Command                                      | What and why                                                                                               |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `sudo journalctl --vacuum-size=200M`         | Shrinks the systemd journal. For a permanent cap, set `SystemMaxUse=200M` in `/etc/systemd/journald.conf`. |
| `sudo apt clean`                             | Deletes downloaded `.deb` files in `/var/cache/apt`. They're re-downloaded if needed.                      |
| `sudo systemctl restart unattended-upgrades` | Restarts automatic security updates if the unit shows as failed.                                           |
| `sudo systemctl reset-failed`                | Clears stale "failed" states left by removed units (e.g. apport, networkd).                                |

### Rollback

Not applicable. These only delete caches and logs, or reset unit state.

---

## Final check

Run these after the last reboot:

```bash
systemctl --failed                                         # empty
grep -c crashkernel /proc/cmdline                          # 0
dpkg -l | awk '/^rc/'                                      # empty (otherwise run section 2)
apt-get -s autoremove | grep -c '^Remv'                    # 0
nmcli dev; tailscale status; docker ps                     # network, VPN, containers up
journalctl -k -b | grep -iE 'failed to load|direct firmware load'   # empty
dpkg -l linux-image-generic linux-firmware-minimal mesa-vulkan-drivers | grep '^ii'   # all 3
```
