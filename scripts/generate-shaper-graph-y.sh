#!/bin/bash

NEWX=$(ls -Art /tmp/resonances_y_*.csv | tail -n 1)
 
if [ ! -d "/home/"${USER}"/klipper_config/input_shaper" ]
then
    mkdir /home/"${USER}"/klipper_config/input_shaper
    chown "${USER}":"${USER}" /home/pi/klipper_config/input_shaper
fi

###if [ ! -d "/home/"${USER}"/klipper_config/input_shaper/csv" ]
###then
###    mkdir /home/"${USER}"/klipper_config/input_shaper/csv
###    chown "${USER}":"${USER}" /home/pi/klipper_config/input_shaper/csv
###fi

if [ -e /home/"${USER}"/klipper_config/input_shaper/old_resonances_y.png ]
then
    cp /home/"${USER}"/klipper_config/input_shaper/old_resonances_y.png /home/"${USER}"/klipper_config/input_shaper/old_old_resonances_y.png
fi

if [ -e /home/"${USER}"/klipper_config/input_shaper/resonances_y.png ]
then
    cp /home/"${USER}"/klipper_config/input_shaper/resonances_y.png /home/"${USER}"/klipper_config/input_shaper/old_resonances_y.png
fi

/home/"${USER}"/klipper/scripts/calibrate_shaper.py $NEWX -o /home/"${USER}"/klipper_config/input_shaper/resonances_y.png

###mv /tmp/resonances_y_*.csv /home/"${USER}"/klipper_config/input_shaper/csv/
rm  /tmp/resonances_y_*.csv