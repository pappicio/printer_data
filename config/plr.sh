#!/bin/bash
############################################
SD_PATH=/home/pi/printer_data/gcodes
############################################ 

var=$4  
#echo var $var
#echo layer height $4
#echo bed     temp $5
#echo s6 ${6}
#echo s6 $6
###{z_height} {last_file} {print_temp} {layer_height} {actual_bed_temp} {macro}

cat ${SD_PATH}/"${2}" > /tmp/plrtmpA.$$

isInFile=$(cat /tmp/plrtmpA.$$ | grep -c "thumbnail")

if [ $isInFile -eq 0 ]; then
    if [ ${var} = 0 ]; then
        echo ';' > ${SD_PATH}/plr.gcode
        echo '' >> ${SD_PATH}/plr.gcode
        echo 'M118 Imposto Temp. Estrusore e bed...' >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed '/ Z'${1}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${SD_PATH}/plr.gcode
        echo M140 S$5 >> ${SD_PATH}/plr.gcode
        echo M104 S$3 >> ${SD_PATH}/plr.gcode
        echo M190 S$5 >> ${SD_PATH}/plr.gcode
        echo M109 S$3 >> ${SD_PATH}/plr.gcode
        echo 'M118 Faccio HOME XY...' >> ${SD_PATH}/plr.gcode
 	cat /tmp/plrtmpA.$$ | sed -e '1,/Z'${1}'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\)/SET_KINEMATIC_POSITION Z=\1/p' >> ${SD_PATH}/plr.gcode    
        echo 'G91' >> ${SD_PATH}/plr.gcode
	echo 'G1 Z5' >> ${SD_PATH}/plr.gcode
	echo 'G90' >> ${SD_PATH}/plr.gcode
	echo 'G28 X Y' >> ${SD_PATH}/plr.gcode
        echo G4 P3000 >> ${SD_PATH}/plr.gcode
        echo 'M118 Attendiamo 30 secondi...' >> ${SD_PATH}/plr.gcode
        echo G4 P30000 >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	###tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p' >> ${SD_PATH}/plr.gcode
	BG_EX=`tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
	# If we failed to match an extrusion command (allowing us to correctly set the E axis) prior to the matched layer height, then simply set the E axis to the first E value present in the resemued gcode.  This avoids extruding a huge blod on resume, and/or max extrusion errors.
	if [ "${BG_EX}" = "" ]; then
	    BG_EX=`tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
	fi
	echo ${BG_EX} >> ${SD_PATH}/plr.gcode
	echo 'G91' >> ${SD_PATH}/plr.gcode
	echo 'G1 Z-5' >> ${SD_PATH}/plr.gcode
	echo 'G90' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
    else
        echo ';' > ${SD_PATH}/plr.gcode
        echo '' >> ${SD_PATH}/plr.gcode
 	echo 'M118 Imposto Temp. Estrusore e bed...' >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed '/ Z'${1}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M140 S/p' | head -1 >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M104 S/p' | head -1 >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M190 S/p' | head -1 >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M109 S/p' | head -1 >> ${SD_PATH}/plr.gcode
        echo 'M118 Faccio HOME XYZ...' >> ${SD_PATH}/plr.gcode
       	echo 'G28 X Y Z' >> ${SD_PATH}/plr.gcode
        echo G4 P3000 >> ${SD_PATH}/plr.gcode
	echo G0 F3000 Z${var} >> ${SD_PATH}/plr.gcode
        cat /tmp/plrtmpA.$$ | sed -e '1,/Z'${1}'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\)/SET_KINEMATIC_POSITION Z=\1/p' >> ${SD_PATH}/plr.gcode    
        echo ${6} >> ${SD_PATH}/plr.gcode
	echo 'Abbasso velocità di stampa al 30%...' >> ${SD_PATH}/plr.gcode
        echo M220 S30 >> ${SD_PATH}/plr.gcode
	echo G4 P3000 >> ${SD_PATH}/plr.gcode
    fi

else
    if [ ${var} = 0 ]; then
        sed -i '1s/^/;start copy\n/' /tmp/plrtmpA.$$
        sed -n '/;start copy/, /thumbnail end/ p' < /tmp/plrtmpA.$$ > ${SD_PATH}/plr.gcode
        echo ';' >> ${SD_PATH}/plr.gcode
        echo '' >> ${SD_PATH}/plr.gcode
        echo 'M118 Imposto Temp. Estrusore e bed...' >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed '/ Z'${1}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${SD_PATH}/plr.gcode
        echo M140 S$5 >> ${SD_PATH}/plr.gcode
        echo M104 S$3 >> ${SD_PATH}/plr.gcode
        echo M190 S$5 >> ${SD_PATH}/plr.gcode
        echo M109 S$3 >> ${SD_PATH}/plr.gcode
        echo 'M118 Faccio HOME XY...' >> ${SD_PATH}/plr.gcode
 	cat /tmp/plrtmpA.$$ | sed -e '1,/Z'${1}'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\)/SET_KINEMATIC_POSITION Z=\1/p' >> ${SD_PATH}/plr.gcode    
        echo 'G91' >> ${SD_PATH}/plr.gcode
	echo 'G1 Z5' >> ${SD_PATH}/plr.gcode
	echo 'G90' >> ${SD_PATH}/plr.gcode
	echo 'G28 X Y' >> ${SD_PATH}/plr.gcode
        echo G4 P3000 >> ${SD_PATH}/plr.gcode
        echo 'M118 Attendiamo 30 secondi...' >> ${SD_PATH}/plr.gcode
        echo G4 P30000 >> ${SD_PATH}/plr.gcode
    	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	###tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p' >> ${SD_PATH}/plr.gcode
	BG_EX=`tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
	# If we failed to match an extrusion command (allowing us to correctly set the E axis) prior to the matched layer height, then simply set the E axis to the first E value present in the resemued gcode.  This avoids extruding a huge blod on resume, and/or max extrusion errors.
	if [ "${BG_EX}" = "" ]; then
	    BG_EX=`tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
	fi
	echo ${BG_EX} >> ${SD_PATH}/plr.gcode
	echo 'G91' >> ${SD_PATH}/plr.gcode
	echo 'G1 Z-5' >> ${SD_PATH}/plr.gcode
	echo 'G90' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
	echo ';' >> ${SD_PATH}/plr.gcode
    else
        sed -i '1s/^/;start copy\n/' /tmp/plrtmpA.$$
        sed -n '/;start copy/, /thumbnail end/ p' < /tmp/plrtmpA.$$ > ${SD_PATH}/plr.gcode
        echo ';' >> ${SD_PATH}/plr.gcode
        echo '' >> ${SD_PATH}/plr.gcode
	echo 'M118 Imposto Temp. Estrusore e bed...' >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed '/ Z'${1}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M140 S/p' | head -1 >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M104 S/p' | head -1 >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M190 S/p' | head -1 >> ${SD_PATH}/plr.gcode
	cat /tmp/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M109 S/p' | head -1 >> ${SD_PATH}/plr.gcode
        echo 'M118 Faccio HOME XYZ...' >> ${SD_PATH}/plr.gcode
       	echo 'G28 X Y Z' >> ${SD_PATH}/plr.gcode
        echo G4 P3000 >> ${SD_PATH}/plr.gcode
	echo G0 F3000 Z${var} >> ${SD_PATH}/plr.gcode
        cat /tmp/plrtmpA.$$ | sed -e '1,/Z'${1}'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\)/SET_KINEMATIC_POSITION Z=\1/p' >> ${SD_PATH}/plr.gcode    
       	echo ${6} >> ${SD_PATH}/plr.gcode
        echo 'Abbasso velocità di stampa al 30%...' >> ${SD_PATH}/plr.gcode
        echo M220 S30 >> ${SD_PATH}/plr.gcode
	echo G4 P3000 >> ${SD_PATH}/plr.gcode

    fi
fi


tac /tmp/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' >> ${SD_PATH}/plr.gcode
/bin/sleep 2
