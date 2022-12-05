to use macro belt_tension and input_shaper:
install gshell_command by kiauh and use example file (shell_command.cfg)
copy intere /script folder into /home/your_user/klipper_config/
and insert shell_command.cfg where is printer.cfg, overwritting the one iet present
restart klipper and use macros!
enjoy!!!



if after update of kiauh (klipper/moonraker) have troubble cos moonraker cannot connect to klipper.....

Check klipper.env file in the printer_data/systemd

For some reason you can end up with serial connection. This needs to be changed back to UDS. It should look like this to work:

KLIPPER_ARGS="/home/pi/klipper/klippy/klippy.py /home/pi/printer_data/config/printer.cfg -l /home/pi/printer_data/logs/klippy.log -a /tmp/klippy_uds"
