#!/bin/bash

actual_path=$(readlink -f "${BASH_SOURCE[0]}")
script_dir=$(dirname "$actual_path")
read usb < $script_dir/serial_by_id.txt
read boot < $script_dir/bootmode_id.txt

 


if test -f "$script_dir/firsttime.txt"; then
    echo ""
else
    echo 'creato per individuare se � la prima esecuzione di questo scritpt!!!!!' > $script_dir/firsttime.txt
    
    echo "****************"
    echo "****************"
    echo ""
    echo "Is first time you execute me!, insert into 'serial_by_is.txt file your own serial_by_id string"
    echo "and"
    echo "your own bootmode id (usually XXX:XXXX format ID) into bootmode_id.txt file."
    echo ""
    echo "Exiting, but NEXT execution, I'll go ON!!!!!! fix thoose files!"
    echo "****************"
    echo "****************"
    exit
fi

if [ -z "$usb" ]; then
    echo "serial_by_id.txt file is empty, please insert into motherboard serial_by_id to continue!"
    echo "exiting..."
    exit
fi

if [ -z "$boot" ]; then
    echo "bootmode_id.txt file is empty, please insert into motherboard BOOTMODE ID to continue!"
    echo "exiting..."
    exit
fi

SUB="replace me with your own "

if grep -q "$SUB" <<< "$usb"; then
    echo "serial_by_id.txt file is incomplete, please insert into motherboard erial_by_id to continue!"
    echo "exiting..."
    exit
fi

if grep -q "$SUB" <<< "$boot"; then
    echo "bootmode_id.txt file is incomplete, please insert into motherboard erial_by_id to continue!"
    echo "exiting..."
    exit
fi


echo "****************"
echo "****************"
echo ""
echo "USB connected on: ${usb}"
echo ""
echo "BOOTMODE ID is: ${boot}"
echo ""
echo "****************"
echo "****************"

echo "****************"
echo "****************"
echo ""
echo "opening octopus config..."
echo ""
echo "****************"
echo "****************"

cp $script_dir/.config_octopus /home/pi/klipper/.config 

cd ~/klipper && git pull && make clean ### && make menuconfig
pid=$!
wait $pid


if test -f "$script_dir/load1mcu.txt"; then
    echo ""
else
    echo 'creato per individuare se � la prima esecuzione di questo scritpt!!!!!' > $script_dir/load1mcu.txt
    cd ~/klipper &&  make menuconfig
    pid=$!
    wait $pid
fi




echo "****************"
echo "****************"
echo ""
echo "backupping new octopus config to use in future..."
echo ""
echo "****************"
echo "****************"

cp /home/pi/klipper/.config $script_dir/.config_octopus


pid=$!
wait $pid

cd /home/pi/klipper

make
pid=$!
wait $pid
sudo service klipper stop 
###make flash FLASH_DEVICE="${usb}"
 if make flash FLASH_DEVICE="${usb}"; then
    echo "Flashing successfull!"
  else
    echo "Flashing failed!"
    echo "Please read the console output above!"
    echo "I'm trying to flash in boot mode..."
     if make flash FLASH_DEVICE="${boot}"; then
      echo "Flashing successfull!"
    else
      echo "Flashing failed!"
      echo "restart printer and try again!!!!!"
      exit
    fi
  fi

pid=$!
wait $pid

#####read -n 1 -r -s -p $'Press any key to continue...\n'


###/dev/serial/by-id/usb-Klipper_stm32f446xx_3E0044000A51373330333137-if00
### make flash FLASH_DEVICE=0483:df11
pid=$!
wait $pid
 
sudo service klipper start
pid=$!
wait $pid

echo "****************"
echo "****************"
echo "****************"
echo ""
echo "MCU Aggiornata!!!"
echo ""
echo "****************"
echo "****************"
echo "****************"

bash $script_dir/mcu.sh