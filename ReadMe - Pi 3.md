### Additional setup stuff for the Pi 3.

### Serial power setup and disabling the console
We need to use the serial port on the Pi.  /dev/ttyAMA0 has been consumed by the new Bluetooth radio and the serial port naming 
convention has changed.  Follow the [instructions here](http://spellfoundry.com/2016/05/29/configuring-gpio-serial-port-raspbian-jessie-including-pi-3/).
