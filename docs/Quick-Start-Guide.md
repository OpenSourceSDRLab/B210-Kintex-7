---
title: B210-Kintex-7 Quick Start Guide
product: B210-Kintex-7
doc_id: OSSDRLAB-B210-Kintex-7-QSG
version: 1.0
date: 2026-11-12
repo: https://github.com/OpenSourceSDRLab/B210-Kintex-7
---

<!-- ossl:header -->
<p><a href="https://www.opensourcesdrlab.com"><img src="../images/OpenSourceSDRLab-banner.jpg" alt="OpenSourceSDRLab" width="100%"></a></p>

# B210-Kintex-7 Quick Start Guide

| Product | Document | Version | Date |
|---|---|---|---|
| B210-Kintex-7 | OSSDRLAB-B210-Kintex-7-QSG | 1.0 | 2026-11-12 |
<!-- /ossl:header -->

## 1. Overview

The B210-Kintex-7 is a USRP B210-compatible software-defined radio. It keeps the AD9361 RF transceiver and the frequency-divided RF front end of the original USRP B210, replaces the Spartan-6 FPGA with a Xilinx Kintex-7 XC7K325T, connects to the host through USB 3.0 Type-C, and adds an onboard GPS module for PPS timing. The GPSDO slot of the original board is removed, which brings the size down to 70 × 97 × 11.5 mm.

The board works with the standard Ettus Research UHD driver and UHD-based software. Because the FPGA is different, it needs its own FPGA image, `usrp_b210_fpga.bin`; this guide shows how to install it and check the board.

Differences in use compared with the original USRP B210:

- the stock `usrp_b210_fpga.bin` from Ettus Research must be replaced with the image for this board;
- a GPSDO module cannot be fitted;
- the PPS from the onboard GPS module has priority over the external PPS input: while the GPS module delivers PPS pulses, the external PPS input is not used.

## 2. What you need

| Item | Notes |
|---|---|
| B210-Kintex-7 board | |
| USB 3.0 Type-C cable | connect to a USB 3.0 (blue) port; USB 2.0 ports do not give enough bandwidth |
| Antennas or RF cables | SMA |
| GPS antenna (optional) | MMCX, for the onboard GPS module |
| PC | 64-bit Windows 10/11 or Ubuntu Linux |
| UHD driver | from Ettus Research: <https://files.ettus.com/binaries/uhd/latest_release/> (Windows installer), or the `uhd-host` package on Ubuntu |
| WinUSB driver (Windows only, if needed) | from Ettus Research: <https://files.ettus.com/binaries/misc/erllc_uhd_winusb_driver.zip> |
| `libusb-1.0.dll` (Windows only, if UHD reports it missing) | from the libusb project (64-bit Windows binaries) |
| FPGA image for this board | `B210-Kintex-7_FPGA-image_Vivado2024.1.zip` from the [Releases](../../../releases) page |

## 3. Connectors and indicators

| Marking | Connector | Function |
|---|---|---|
| TRX1, TRX2 | SMA | transmit or receive port, channel 1 / 2 |
| RX1, RX2 | SMA | receive port, channel 1 / 2 |
| USB | USB 3.0 Type-C | data and power from the host |
| PPS | MMCX | external PPS input |
| 10M | MMCX | external 10 MHz reference input |
| GPS | MMCX | antenna input of the onboard GPS module |
| FPC connector | FPC | FPGA JTAG and spare GPIO |

| LED | Meaning |
|---|---|
| PWER | power; red when the board is powered |
| STAS | status; blue after the FPGA image has been loaded |
| CLK | PPS; flashes red in step with the selected PPS source |
| USR | no function by default, free for user designs |
| TRX1, TRX2 | red while transmitting, blue while receiving |
| RX1, RX2 | blue while receiving |

## 4. Set up on Windows

1. Download the UHD installer for your Windows version from Ettus Research (see section 2), right-click it and run it as administrator. Keep the default installation folder `C:\Program Files\UHD`.

2. Connect the board. In Device Manager it should appear as **Ettus Research LLC B200/B210** under **USRPs**. If it shows up as an unknown device, choose **Update driver**, point it to the driver folder in the UHD installation, or unzip `erllc_uhd_winusb_driver.zip` and point it to that folder.

3. Make sure the standard UHD images (including the FX3 firmware `usrp_b200_fw.hex`) are in `C:\Program Files\UHD\share\uhd\images\`. If the folder is empty, download them in a Command Prompt run as administrator (needs Python):

        cd "C:\Program Files\UHD\lib\uhd\utils"
        python uhd_images_downloader.py

4. Unzip `B210-Kintex-7_FPGA-image_Vivado2024.1.zip` and copy `usrp_b210_fpga.bin` over the file of the same name in `C:\Program Files\UHD\share\uhd\images\`.

5. Open a Command Prompt in `C:\Program Files\UHD\bin` and run:

        uhd_find_devices
        uhd_usrp_probe

    `uhd_find_devices` should list a **B210** with its serial number, and `uhd_usrp_probe` should print the full device tree (FPGA version, RX/TX channels, frequency and gain ranges).

> **Tip:** if `uhd_usrp_probe` says that `libusb-1.0.dll` is missing, copy `libusb-1.0.dll` (64-bit) into `C:\Program Files\UHD\bin` and run it again.

> **Tip:** the error `RuntimeError: fx3 is in state 5` means the stock Ettus FPGA image was loaded. Repeat step 4. `uhd_usrp_probe` prints the path of the image it loads.

> **Tip:** some applications bring their own copy of UHD and of `usrp_b210_fpga.bin` (for example SDR# with a USRP plug-in). Replace the image in that program's folder too.

## 5. Set up on Ubuntu Linux

1. Install UHD:

        sudo apt update
        sudo apt install -y libuhd-dev uhd-host

2. Download the standard images and replace the FPGA image:

        sudo uhd_images_downloader
        uhd_find_devices        # prints the images folder if the image is wrong

    Copy `usrp_b210_fpga.bin` from the release zip over the file of the same name in the UHD images folder (usually `/usr/share/uhd/images/`). If you keep the images in your own folder, set `UHD_IMAGES_DIR` to that folder.

3. Allow normal users to access the board (only needed if UHD reports a permission error):

        sudo tee /etc/udev/rules.d/10-usrp.rules >/dev/null << 'EOF'
        SUBSYSTEM=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0020", MODE="0666"
        EOF
        sudo udevadm control --reload-rules && sudo udevadm trigger

4. Connect the board to a USB 3.0 port and check it with `uhd_find_devices` and `uhd_usrp_probe` as on Windows.

## 6. First signals

Each channel has two SMA ports. In UHD-based software, the channel is chosen with the subdevice (`subdev`) and the port with the antenna setting:

| Board port | Subdevice | Antenna |
|---|---|---|
| TRX1 | `A:A` | `TX/RX` |
| RX1 | `A:A` | `RX2` |
| TRX2 | `A:B` | `TX/RX` |
| RX2 | `A:B` | `RX2` |

For example, the Gqrx device string for the RX2 port is `uhd,type=b200,subdev=A:B` with the antenna set to `RX2`.

Once `uhd_usrp_probe` passes, any UHD-based application can use the board: GNU Radio, SDRangel, Gqrx, Universal Radio Hacker and others. Two GNU Radio Companion examples are in `examples/gnuradio/` of the repository: a two-channel receiver and a TX-to-RX loop-back test.

Step-by-step instructions for these applications are in the user manual on our blog: <https://blog.opensourcesdrlab.com/archives/kintex-7-usrp-b210-user-manual>

## 7. FPGA source project

| Path | Contents |
|---|---|
| `fpga/B210_Project_Firmwire.xpr` | Vivado 2024.1 project, target `xc7k325tffg676-2`, top module `b200` |
| `fpga/B210_Project_Firmwire.srcs/sources_1/imports/.../lib/`, `.../top/b200/` | Ettus Research USRP FPGA sources (UHD v4.9.0.0), with the board changes listed in `NOTICE.md` |
| `fpga/top/b200/` | board constraints `b210.xdc`, PPS selection logic, halfband filter netlists |
| `fpga/B210_Project_Firmwire.srcs/sources_1/ip/` | Xilinx IP configurations (clocking wizard, FIFOs) |

To rebuild the image:

1. Open `fpga/B210_Project_Firmwire.xpr` in Vivado 2024.1. Vivado regenerates the IP output products the first time.
2. Run **Generate Bitstream**. The project writes `b200.bit` and `b200.bin` to `B210_Project_Firmwire.runs/impl_1/`.
3. Rename `b200.bin` to `usrp_b210_fpga.bin` and install it as in section 4 or 5.

## 8. Support

- Email: support@opensourcesdrlab.com
- Forum: <https://forum.opensourcesdrlab.com>
- Discord: <https://discord.gg/nnxY6DkmvT>
- Blog and user manuals: <https://blog.opensourcesdrlab.com>

<!-- ossl:footer -->
---
<sub>© 2026 OpenSourceSDRLab. All rights reserved. · <a href="https://www.opensourcesdrlab.com">www.opensourcesdrlab.com</a></sub>
<!-- /ossl:footer -->
