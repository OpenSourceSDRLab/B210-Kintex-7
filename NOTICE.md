# Third-party notices

This repository and its release files contain work by OpenSourceSDRLab together with third-party work. The Apache License 2.0 in [LICENSE](LICENSE) applies **only** to the files created by OpenSourceSDRLab:

- `docs/`, `hardware/`, `images/`, `examples/`, `README.md`, `NOTICE.md`
- in `fpga/`:
  - `top/b200/b210.xdc` (pin and timing constraints for this board)
  - `top/b200/Define.vh`
  - `top/b200/edge_detect.v`, `top/b200/pps_switch.v` (selection between the onboard GPS PPS and the external PPS input)
  - the Vivado project file `B210_Project_Firmwire.xpr`

All other files keep their original copyright notices and licences, which have not been changed:

| Component | Files | Owner | Licence |
|---|---|---|---|
| USRP B200/B210 FPGA design (UHD `fpga/usrp3`, release v4.9.0.0) | `fpga/B210_Project_Firmwire.srcs/sources_1/imports/B210_Project_Firmwire/lib/` and `.../top/b200/` | Ettus Research, a National Instruments brand | GNU LGPL v3 or later, see [fpga/LICENSE.md](fpga/LICENSE.md) and [fpga/COPYING.GPL-3](fpga/COPYING.GPL-3) |
| White Rabbit PTP core firmware images | `fpga/.../lib/white_rabbit/wr_cores_v4_2/bin/wrpc/*.mif` (shipped with UHD) | CERN and the White Rabbit project contributors (ohwr.org) | White Rabbit project terms, as distributed with UHD |
| Halfband decimator netlists | `fpga/top/b200/coregen_dsp/hbdec1.edif`, `hbdec2.edif` (EDIF versions, written by Xilinx `ngc2edif`, of the CORE Generator netlists `hbdec1.ngc` and `hbdec2.ngc` in UHD `top/b200/coregen_dsp/`) | Xilinx, Inc. / AMD, distributed by Ettus Research | Xilinx/AMD licence terms |
| Xilinx IP configurations | `fpga/B210_Project_Firmwire.srcs/sources_1/ip/*/*.xci` (clocking wizard, FIFO generator) | Xilinx, Inc. / AMD | Xilinx/AMD licence terms |
| FPGA image `usrp_b210_fpga.bin` | Releases | built by OpenSourceSDRLab from `fpga/`; contains the Ettus Research and Xilinx parts listed above | LGPL v3 for the Ettus Research parts; the corresponding source is the `fpga/` folder of this repository |

The following files from UHD v4.9.0.0 were **modified by OpenSourceSDRLab** for this board (Kintex-7 FPGA, GPS/PPS selection, pin-out). Their Ettus Research copyright notices and LGPL licence statements are unchanged:

- `fpga/.../top/b200/b200.v`, `b200_core.v`, `b200_io.v`
- `fpga/.../lib/control/reset_sync.v` (same as in UHD 4.5 to 4.8)

All other files under `fpga/.../lib/` are identical to UHD v4.9.0.0 (<https://github.com/EttusResearch/uhd/tree/v4.9.0.0/fpga/usrp3>).

Software that is **not** included and must be obtained from the original publishers:

- the UHD driver, its Windows installer and the WinUSB driver package from Ettus Research: <https://files.ettus.com/binaries/uhd/latest_release/>, <https://files.ettus.com/binaries/misc/erllc_uhd_winusb_driver.zip>;
- `libusb-1.0.dll` from the libusb project;
- Xilinx/AMD Vivado 2024.1, needed to rebuild the FPGA image.

"Ettus Research", "USRP", "UHD", "Analog Devices", "AD9361", "Xilinx", "Kintex" and "Vivado" are trademarks of their respective owners. They are used here only to describe compatibility and do not imply endorsement.
