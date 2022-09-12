#!/bin/bash
 
sleep 10

outdir=/home/"${USER}"/klipper_config/belt_tension
csvdir=/home/"${USER}"/klipper_config/belt_tension/csv

if [ ! -d "${outdir}" ]; then
    mkdir "${outdir}"
    chown pi:pi "${outdir}" 
fi
###if [ ! -d "${csvdir}" ]; then
###    mkdir "${csvdir}"
###    chown pi:pi "${csvdir}" 
###fi


if [ -e /home/"${USER}"/klipper_config/belt_tension/4_old_resonances.png ]
then
    cp /home/"${USER}"/klipper_config/belt_tension/4_old_resonances.png /home/"${USER}"/klipper_config/belt_tension/5_old_resonances.png
fi

if [ -e /home/"${USER}"/klipper_config/belt_tension/3_old_resonances.png ]
then
    cp /home/"${USER}"/klipper_config/belt_tension/3_old_resonances.png /home/"${USER}"/klipper_config/belt_tension/4_old_resonances.png
fi

if [ -e /home/"${USER}"/klipper_config/belt_tension/2_old_resonances.png ]
then
    cp /home/"${USER}"/klipper_config/belt_tension/2_old_resonances.png /home/"${USER}"/klipper_config/belt_tension/3_old_resonances.png
fi


if [ -e /home/"${USER}"/klipper_config/belt_tension/1_old_resonances.png ]
then
    cp /home/"${USER}"/klipper_config/belt_tension/1_old_resonances.png /home/"${USER}"/klipper_config/belt_tension/2_old_resonances.png
fi

if [ -e /home/"${USER}"/klipper_config/belt_tension/resonances.png ]
then
    cp /home/"${USER}"/klipper_config/belt_tension/resonances.png /home/"${USER}"/klipper_config/belt_tension/1_old_resonances.png 
fi
 

/home/"${USER}"/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /home/"${USER}"/klipper_config/belt_tension/resonances.png
###mv /tmp/raw_data_axis*.csv "${csvdir}"
rm /tmp/raw_data_axis*.csv