#!/bin/bash
############################################
SD_PATH=/home/pi/printer_data/gcodes
############################################ 

echo nome del file last file: $2
echo bed temp $4

###{z_height} {last_file} {print_temp} {actual_bed_temp}
cat ${SD_PATH}/"${2}" > /tmp/plrtmpA.$$

isInFile=$(cat /tmp/plrtmpA.$$ | grep -c "thumbnail")
if [ $isInFile -eq 0 ]; then
        echo ';' >> ${SD_PATH}/plr.gcode
        echo '' >> ${SD_PATH}/plr.gcode
        echo 'M118 START_TEMPS...' >> ${SD_PATH}/plr.gcode
        echo M140 S$4 >> ${SD_PATH}/plr.gcode
        echo M104 S$3 >> ${SD_PATH}/plr.gcode
        echo M190 S$4 >> ${SD_PATH}/plr.gcode
        echo M109 S$3 >> ${SD_PATH}/plr.gcode
        echo 'M118 GOTO HOME...' >> ${SD_PATH}/plr.gcode
 	cat /tmp/plrtmpA.$$ | sed -e '1,/Z'${1}'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\)/SET_KINEMATIC_POSITION Z=\1/p' >> ${SD_PATH}/plr.gcode    
        echo 'G91' >> ${SD_PATH}/plr.gcode
	echo 'G1 Z5' >> ${SD_PATH}/plr.gcode
	echo 'G90' >> ${SD_PATH}/plr.gcode
	echo 'G28 X Y' >> ${SD_PATH}/plr.gcode
	echo 'G1 F200 E0.5' >> ${SD_PATH}/plr.gcode
        echo G4 P3000 >> ${SD_PATH}/plr.gcode
        echo 'M118 Attendiamo 30 secondi...' >> ${SD_PATH}/plr.gcode
        echo G4 P30000 >> ${SD_PATH}/plr.gcode
else
        sed -i '1s/^/;start copy\n/' /tmp/plrtmpA.$$
        sed -n '/;start copy/, /thumbnail end/ p' < /tmp/plrtmpA.$$ > ${SD_PATH}/plr.gcode
        echo ';' >> ${SD_PATH}/plr.gcode
        echo '' >> ${SD_PATH}/plr.gcode
        echo 'M118 START_TEMPS...' >> ${SD_PATH}/plr.gcode
        echo M140 S$4 >> ${SD_PATH}/plr.gcode
        echo M104 S$3 >> ${SD_PATH}/plr.gcode
        echo M190 S$4 >> ${SD_PATH}/plr.gcode
        echo M109 S$3 >> ${SD_PATH}/plr.gcode
        echo 'M118 GOTO HOME...' >> ${SD_PATH}/plr.gcode
 	cat /tmp/plrtmpA.$$ | sed -e '1,/Z'${1}'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\)/SET_KINEMATIC_POSITION Z=\1/p' >> ${SD_PATH}/plr.gcode    
        echo 'G91' >> ${SD_PATH}/plr.gcode
	echo 'G1 Z5' >> ${SD_PATH}/plr.gcode
	echo 'G90' >> ${SD_PATH}/plr.gcode
	echo 'G28 X Y' >> ${SD_PATH}/plr.gcode
	echo 'G1 F200 E0.5' >> ${SD_PATH}/plr.gcode
        echo G4 P3000 >> ${SD_PATH}/plr.gcode
        echo 'M118 Attendiamo 30 secondi...' >> ${SD_PATH}/plr.gcode
        echo G4 P30000 >> ${SD_PATH}/plr.gcode
fi
echo ';' >> ${SD_PATH}/plr.gcode
echo ';' >> ${SD_PATH}/plr.gcode
echo ';' >> ${SD_PATH}/plr.gcode
tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p' >> ${SD_PATH}/plr.gcode
echo 'G91' >> ${SD_PATH}/plr.gcode
echo 'G1 Z-5' >> ${SD_PATH}/plr.gcode
echo 'G90' >> ${SD_PATH}/plr.gcode
echo ';' >> ${SD_PATH}/plr.gcode
echo ';' >> ${SD_PATH}/plr.gcode
echo ';' >> ${SD_PATH}/plr.gcode

tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' >> ${SD_PATH}/plr.gcode
/bin/sleep 2