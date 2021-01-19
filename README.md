# ecoar-mips32
MIPS32 assembly project for Computer Architecture course at Faculty of Electronics of Warsaw University of Technology.

## Functionality 
The task was to create turtle graphics program which displays drawings on the bitmap display of MARS (MIPS Assembler and Runtime Simulator). Program works on 64x64 px display with unit width and height of 1 pixel. User may either change colour (in 24-bit RGB colour space) or draw a line on display in the given direction.

## Setup
Connect bitmap display to the heap in MARS, set bitmap's size to 64x64 px. Unit size should remain unchanged. Assemble main.asm and run.

## Usage
The program accepts three types of commands:
* C \<red> \<green> \<blue> - change colour of pixels; values of red, green and blue are in range 0-255 (as it is 24-bit encoding)
* \<direction> \<steps> - draw line in given direction (N, W, SE, etc.) made of given number of pixels; direction parameter is case insensitive;
* q - terminate the program
