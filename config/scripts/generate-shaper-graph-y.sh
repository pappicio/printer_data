#!/bin/bash

NEWX=$(ls -Art /tmp/resonances_y_*.csv | tail -n 1)
 
if [ ! -d "/home/"${USER}"/printer_data/config/input_shaper" ]
then
    mkdir /home/"${USER}"/printer_data/config/input_shaper
    chown "${USER}":"${USER}" /home/pi/printer_data/config/input_shaper
fi

###if [ ! -d "/home/"${USER}"/printer_data/config/input_shaper/csv" ]
###then
###    mkdir /home/"${USER}"/printer_data/config/input_shaper/csv
###    chown "${USER}":"${USER}" /home/pi/printer_data/config/input_shaper/csv
###fi

if [ -e /home/"${USER}"/printer_data/config/input_shaper/4_old_resonances_y.png ]
then
    cp /home/"${USER}"/printer_data/config/input_shaper/4_old_resonances_y.png /home/"${USER}"/printer_data/config/input_shaper/5_old_resonances_y.png
fi

if [ -e /home/"${USER}"/printer_data/config/input_shaper/3_old_resonances_y.png ]
then
    cp /home/"${USER}"/printer_data/config/input_shaper/3_old_resonances_y.png /home/"${USER}"/printer_data/config/input_shaper/4_old_resonances_y.png
fi

if [ -e /home/"${USER}"/printer_data/config/input_shaper/2_old_resonances_y.png ]
then
    cp /home/"${USER}"/printer_data/config/input_shaper/2_old_resonances_y.png /home/"${USER}"/printer_data/config/input_shaper/3_old_resonances_y.png
fi

if [ -e /home/"${USER}"/printer_data/config/input_shaper/1_old_resonances_y.png ]
then
    cp /home/"${USER}"/printer_data/config/input_shaper/1_old_resonances_y.png /home/"${USER}"/printer_data/config/input_shaper/2_old_resonances_y.png
fi

if [ -e /home/"${USER}"/printer_data/config/input_shaper/resonances_y.png ]
then
    cp /home/"${USER}"/printer_data/config/input_shaper/resonances_y.png /home/"${USER}"/printer_data/config/input_shaper/1_old_resonances_y.png
fi

/home/"${USER}"/klipper/scripts/calibrate_shaper.py $NEWX -o /home/"${USER}"/printer_data/config/input_shaper/resonances_y.png

###mv /tmp/resonances_y_*.csv /home/"${USER}"/printer_data/config/input_shaper/csv/
rm  /tmp/resonances_y_*.csv