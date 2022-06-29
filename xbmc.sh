#!/bin/bash


#Uruchamia srodowisko xbmc.


if [ -f /etc/systemd/logind.conf ] && [ "${1}" == "start" ]
then
 if [ "${2}" == "xbmc" ]
 then
  if [ `dpkg -s xbmc 2> /dev/null | egrep "^Status" | egrep "install ok installed" | wc -l` -ne 1 ]
  then
   sudo apt-get install python-software-properties pkg-config
   sudo apt-get install software-properties-common

   sudo add-apt-repository ppa:team-xbmc/ppa

   sudo apt-get update
   sudo apt-get update

   sudo apt-get install xbmc
  fi
 fi

 if [ "${2}" != "xbmc" ]
 then
  cp -r /etc/systemd/logind.conf .

  echo "HandleLidSwitch=ignore" >> logind.conf

  sudo mv logind.conf /etc/systemd/logind.conf

  sudo restart systemd-logind
 fi

 sleep 2s

 xrandr --output LVDS1 --off --output HDMI1 --auto

 sleep 2s

 pactl set-card-profile 0 output:hdmi-stereo

 sleep 2s

 gsettings set org.gnome.desktop.session idle-delay 1800
 gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

 if [ "${2}" == "xbmc" ]
 then
  xbmc
 else
  if [ "${2}" == "vlc" ]
  then
   vlc
  fi
 fi
elif [ -f /etc/systemd/logind.conf ] && [ "${1}" == "stop" ]
then
 if [ "${2}" != "xbmc" ]
 then
  cp -r /etc/systemd/logind.conf .

  cat logind.conf | egrep -v "^HandleLidSwitch\=ignore" > tmp

  mv tmp logind.conf

  sudo mv logind.conf /etc/systemd/logind.conf

  sudo restart systemd-logind
 fi

 sleep 2s

 xrandr --output LVDS1 --auto --output HDMI1 --off

 sleep 2s

 pactl set-card-profile 0 output:analog-stereo

 sleep 2s

 gsettings set org.gnome.desktop.session idle-delay 180
 gsettings set org.gnome.desktop.screensaver idle-activation-enabled true
else
 echo "[ USAGE ]: ${0} <start/stop> <xbmc/noxbmc/vlc>" > /dev/stderr
fi


exit 0
