#/bin/bash


if [ "${#}" -eq 3 ] && [ "${1}" == "mount" ]
then
 if [ -e /dev/nbd0 ]
 then
  sudo rmmod nbd 2> /dev/null
 fi

 sudo modprobe nbd max_part=16

 if [ -f ${2} ] && [ -e /dev/nbd0 ]
 then
  sudo qemu-nbd -c /dev/nbd0 ${2}
 elif [ ! -f ${2} ]
 then
  echo "[ ERROR ]: Unable to find \"${2}\" file!"
  exit 0
 elif [ ! -e /dev/nbd0 ]
 then
  echo "[ ERROR ]: Unable to find \"/dev/nbd0\"!"
  exit 0
 fi

 sleep 5

 if [ -d ${3} ] && [ -e /dev/nbd0p1 ]
 then
  sudo mount /dev/nbd0p1 ${3}
 elif [ ! -d ${3} ]
 then
  echo "[ ERROR ]: Unable to find \"${3}\" directory!"
  exit 0
 elif [ ! -e /dev/nbd0p1 ]
 then
  echo "[ ERROR ]: Unable to find \"/dev/nbd0p1\"!"
  exit 0
 fi
elif [ "${#}" -eq 3 ] && [ "${1}" == "unmount" ]
then
 if [ -d ${3} ]
 then
  sudo umount ${3}
 elif [ ! -d ${3} ]
 then
  echo "[ ERROR ]: Unable to find \"${3}\" directory!"
  exit 0
 fi

 if [ -e /dev/nbd0 ]
 then
  sudo qemu-nbd -d /dev/nbd0

  sudo rmmod nbd 2> /dev/null
 elif [ ! -e /dev/nbd0 ]
 then
  echo "[ ERROR ]: Unable to find \"/dev/nbd0\"!"
  exit 0
 fi
else
 echo "[ USAGE ]: ${0} <mount|unmount> /path/to/vdi/file /mnt-point!"
fi


exit 0
