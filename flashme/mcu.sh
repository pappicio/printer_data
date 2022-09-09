#!/bin/bash


actual_path=$(readlink -f "${BASH_SOURCE[0]}")
script_dir=$(dirname "$actual_path")

echo "****************"
echo "****************"
echo ""
echo "opening mcu config..."
echo ""
echo "****************"
echo "****************"
 

 

echo "****************"
echo "****************"
echo ""
echo "copying linux MCU config..."
echo ""
echo "****************"
echo "****************"
cp $script_dir/.config_mcu /home/pi/klipper/.config 
cd ~/klipper && git pull && make clean ### && make menuconfig
pid=$!
wait $pid

if test -f "$script_dir/load2mcu.txt"; then
    echo ""
else
    echo 'creato per individuare se è la prima esecuzione di questo scritpt!!!!!' > $script_dir/load2mcu.txt
    make menuconfig
    pid=$!
    wait $pid
fi


echo "****************"
echo "****************"
echo ""
echo "backupping linux MCU config to use in future..."
echo ""
echo "****************"
echo "****************"


cp /home/pi/klipper/.config $script_dir/.config_mcu
sudo service klipper stop
make flash
pid=$!
wait $pid

sudo service klipper start
pid=$!
wait $pid

echo "****************"
echo "****************"
echo "****************"
echo ""
echo "fatto!"
echo ""
echo "****************"
echo "****************"
echo "****************"
