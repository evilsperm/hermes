#!/bin/bash
#
# Copyright (C) Youness Alaoui (KaKaRoTo)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

#----------- CHECK raw2payload ----------

echo -n "Checking raw2payload.c location ... "

if [ ! -f raw2payload.c ]
then
	mv $(find -name 'raw2payload.c') ./raw2payload.c
fi

echo "Done!"

#---------- PATCH Makefile.payload -----------

echo -n "Patching Makefile.payload ... "

sed -e '0,/^[ ]*R2PTARGET[ ]*=.*$/s//R2PTARGET = raw2payload/' \
-e '0,/^[ ]*PS3_COMPILERS[ ]*=.*$/s//#PS3_COMPILERS = G:\/ps3\/dev\/ppu\/bin/' \
-e '0,/^[ ]*PPU_CC[ ]*=.*$/s//PPU_CC = ppu-gcc/' \
-e '0,/^[ ]*PPU_OBJCOPY[ ]*=.*$/s//PPU_OBJCOPY = ppu-objcopy/' \
-e '0,/^.*$(R2PTARGET):.*$/s//$(R2PTARGET): raw2payload.c/' \
-e '0,/^.*$(CC)[ ]*$(CFLAGS).*$/s//\t$(CC) $(CFLAGS) $< -o $@/' \
-e '0,/^.*$< $@ $(\*F).*$/s//\t$(PWD)\/$(R2PTARGET) $< $@ $(\*F)/' \
-e '0,/^.*$(REMOVE)[ ]*$(R2PTARGET).*$/s//\t$(REMOVE) $(R2PTARGET)/' Makefile.payload>Makefile.payload.a

mv Makefile.payload.a Makefile.payload

echo "Done!"

#---------- Make the Hex files -----------

all_targets="teensy1 teensypp1 teensy2 teensypp2 \
              at90usbkey minimus1 minimus32 maximus \
              blackcat xplain olimex usbtinymkii \
              bentio"
			  
			  
avr_gcc_ver=`avr-gcc --version | head -n 1 | awk '{print $3}'`
if [[ $avr_gcc_ver < "4.3.5" ]]; then
  echo "OpenKubus compilation disabled. You need avr-gcc version 4.3.5 or later."
  echo "(You currently have avr-gcc version ${avr_gcc_ver})"
else
  all_targets="${all_targets} openkubus"
fi

i=1
for target in ${all_targets}; do
  let ${target}=$i
  let i++
done

mcu[$teensy1]=at90usb162
board[$teensy1]=TEENSY
mhz_clock[$teensy1]=16
name[$teensy1]="Teensy 1.0"

mcu[$teensypp1]=at90usb646
board[$teensypp1]=TEENSY
mhz_clock[$teensypp1]=16
name[$teensypp1]="Teensy++ 1.0"

mcu[$teensy2]=atmega32u4
board[$teensy2]=TEENSY
mhz_clock[$teensy2]=16
name[$teensy2]="Teensy 2.0"

mcu[$teensypp2]=at90usb1286
board[$teensypp2]=TEENSY
mhz_clock[$teensypp2]=16
name[$teensypp2]="Teensy++ 2.0"

mcu[$at90usbkey]=at90usb1287
board[$at90usbkey]=USBKEY
mhz_clock[$at90usbkey]=8
name[$at90usbkey]="AT90USBKEY"

mcu[$minimus1]=at90usb162
board[$minimus1]=MINIMUS
mhz_clock[$minimus1]=16
name[$minimus1]="Minimus v1"

mcu[$minimus32]=atmega32u2
board[$minimus32]=MINIMUS
mhz_clock[$minimus32]=16
name[$minimus32]="Minimus 32"

mcu[$maximus]=at90usb162
board[$maximus]=MAXIMUS
mhz_clock[$maximus]=16
name[$maximus]="Maximus"

mcu[$blackcat]=at90usb162
board[$blackcat]=BLACKCAT
mhz_clock[$blackcat]=16
name[$blackcat]="Blackcat"

mcu[$xplain]=at90usb1287
board[$xplain]=XPLAIN
mhz_clock[$xplain]=8
name[$xplain]="XPLAIN"

mcu[$olimex]=at90usb162
board[$olimex]=OLIMEX
mhz_clock[$olimex]=8
name[$olimex]="Olimex"

mcu[$usbtinymkii]=at90usb162
board[$usbtinymkii]=USBTINYMKII
mhz_clock[$usbtinymkii]=16
name[$usbtinymkii]="USBTINYMKII"

mcu[$bentio]=at90usb162
board[$bentio]=BENTIO
mhz_clock[$bentio]=16
name[$bentio]="Bentio"

mcu[$openkubus]=atmega16u4
board[$openkubus]=USBKEY
mhz_clock[$openkubus]=8
name[$openkubus]="OpenKubus"


while [ "x$1" != "x" ]; do
  targets="$targets ${1}"
  shift
done
if [ "x$targets" == "x" ]; then
  for i in ${all_targets}; do
    targets="$targets ${i}"
  done
fi

echo "Building for targets : $targets"

rm -rf psgroove_hex/
mkdir psgroove_hex
make clean > /dev/null

for target in ${targets}; do
    low_board=`echo ${board[${!target}]} | awk '{print tolower($0)}'`
    filename="psgroove_${low_board}_${mcu[${!target}]}_${mhz_clock[${!target}]}mhz_firmware3.41"
    echo "Compiling $filename for ${name[${!target}]}"
	
	sed -e "0,/^[ ]*MCU[ ]*=.*$/s//MCU = ${mcu[${!target}]}/" \
	-e "0,/^[ ]*BOARD[ ]*=.*$/s//BOARD = ${board[${!target}]}/" \
	-e "0,/^[ ]*F_CPU[ ]*=.*$/s//F_CPU = ${mhz_clock[${!target}]}000000/" Makefile.psgroove>Makefile.psgroove.a

	mv Makefile.psgroove.a Makefile.psgroove
	
	make > /dev/null
	
    #make TARGET=$filename MCU=${mcu[${!target}]} BOARD=${board[${!target}]} F_CPU=${mhz_clock[${!target}]}000000 > /dev/null || exit 1
    	
	mkdir -p "psgroove_hex/${name[${!target}]}"
    mv psgroove.hex "psgroove_hex/${name[${!target}]}/${filename}.hex"
    make clean > /dev/null
done
