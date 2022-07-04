# Working order

1. Send bytes to esp32 (done)
2. Send command packets and recive status byte. (work in progress)
3. Get esp32 do work as a hard drive.
4. Build ACSI support into FujiNet support for .st .msa and had drive image files.
## Fujinet-config-st

Written in C
Works both as an .ACC and a bootable .PRG program

## fujinet.sys
Drivers for fujinet includes:
1 disk drivers
2 network drivers
3 printer spooler
