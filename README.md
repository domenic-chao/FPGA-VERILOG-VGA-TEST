# VGA IN VERILOG
Sync pulse for 640 by 480 is `LOW` with active, front porch and back porch being `HIGH`. The DE-10 Standard Board I used had 24 bit color (8 per color). Ensure that you tie the clock to 25 Mhz clock used for setting colors. 640 by 480 needs a clock of 25.17Mhz but from testing 25 Mhz works fine.

## Order of Operation for VGA:

|Mode|HSYNC PIXELS|VSYNC PIXELS|Signal|
|---|----|---|---|
|Active Video|640|480|HIGH|
|Front Porch|16|10|HIGH|
|Sync Pulse|96|2|LOW|
|Back Porch|48|33|HIGH|
|TOTAL|800|525||
