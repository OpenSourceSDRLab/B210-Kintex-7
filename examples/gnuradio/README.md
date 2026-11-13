# GNU Radio examples

GNU Radio Companion flowgraphs for the B210-Kintex-7 (GNU Radio 3.10 or later, with the UHD blocks).

| File | What it does |
|---|---|
| `two_channel_receive.grc` | Receives on both channels at the same time and shows the spectrum and time signal of each (centre frequency 5.8 GHz, 5 MS/s by default) |
| `two_channel_loop.grc` | Transmits a 1 MHz tone on both TX channels and receives both RX channels, for a loop-back test |

Both flowgraphs open the first USRP that UHD finds. To pick a specific board, put `"serial=<serial number>"` in the **Device Address** field of the UHD blocks (`uhd_find_devices` lists the serial numbers).

> **Caution:** for a cabled loop-back test, put at least 30 dB of attenuation between each TX and RX port and start with low TX gain, or the receiver can be damaged.
