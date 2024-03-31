#!/bin/bash


actual_path=$(readlink -f "${BASH_SOURCE[0]}")
script_dir=$(dirname "$actual_path")



KLIPPY_ENV="${HOME}/klippy-env"

python_version=$("${KLIPPY_ENV}"/bin/python --version 2>&1 | cut -d" " -f2 | cut -d"." -f1)

echo "****************"
echo "****************"
echo ""

echo Klipper Python version is: $python_version
###exit 0


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

 
  
    if ( python_version == 3 ); then
        make PYTHON=python3 menuconfig
        make PYTHON=python3
    else
        make PYTHON=python2 menuconfig
        make PYTHON=python2
    fi


    // cd ~/klipper &&  make menuconfig
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
