=======================================================================================
					Description of the source code Level2.asm:
=======================================================================================
Input:  KEY3, KEY2, KEY1
Output: PORT_HEX0[7-0],PORT_HEX1[7-0],PORT_HEX2[7-0],PORT_HEX3[7-0],PORT_HEX4[7-0],
		PORT_HEX5[7-0],PORT_LEDR[7-0]
RESET:  Pushbutton KEY0
----------------------------------------------------------------------------------------
On KEY1 pushing:
---------------
read the PORT_SW[7-0] and write it to ports PORT_HEX0[7-0],PORT_HEX1[7-0],PORT_LEDR[7-0]

On KEY2 pushing:
---------------
read the PORT_SW[7-0] and write it to ports PORT_HEX2[7-0],PORT_HEX3[7-0],PORT_LEDR[7-0]

On KEY3 pushing:
---------------
read the PORT_SW[7-0] and write it to ports PORT_HEX4[7-0],PORT_HEX5[7-0],PORT_LEDR[7-0]