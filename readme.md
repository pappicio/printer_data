to use macro belt_tension and input_shaper:
install gshell_command by kiauh and use example file (shell_command.cfg)
copy intere /script folder and input_shaper.cfg into /home/your_user/klipper_config/
insertinf it where is printer.cfg
include config into printer.cfg by editing printer.cfg adding this line at beginning:

[include input_shaper.cfg]

save printer.cfg and restart klipper and use macros!
enjoy!!!



if after update of kiauh (klipper/moonraker) have troubble cos moonraker cannot connect to klipper.....

Check klipper.env file in the printer_data/systemd

For some reason you can end up with serial connection. This needs to be changed back to UDS. It should look like this to work:

KLIPPER_ARGS="/home/pi/klipper/klippy/klippy.py /home/pi/printer_data/config/printer.cfg -l /home/pi/printer_data/logs/klippy.log -a /tmp/klippy_uds"
