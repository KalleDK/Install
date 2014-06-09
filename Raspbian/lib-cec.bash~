#!/bin/bash
cd /home/pi
sudo apt-get -Y install build-essential autoconf liblockdev1-dev libudev-dev git libtool pkg-config
sudo git clone git://github.com/Pulse-Eight/libcec.git
cd libcec
sudo ./bootstrap
sudo ./configure --with-rpi-include-path=/opt/vc/include --with-rpi-lib-path=/opt/vc/lib --enable-rpi
sudo make
sudo make install
sudo ldconfig
