#!/bin/bash


#Konwersja tekstu na mowe.


if [ ${#} -ne 1 ] && [ ${#} -ne 2 ]
then
 echo "[ ERROR ]: ${0} <text> [repeat_n_times]!" > /dev/stderr
 exit 0
fi


cd `dirname ${0}`

if [ `ping -c 5 8.8.8.8 2> /dev/null | egrep ", 0% packet loss," | wc -l` -eq 1 ]
then
 rm -rf out*.mp3

 A="${1}"

 SIZE=${#A}

 #Odkad zaczynamy brac string.
 i=0

 #Numeracja plikow dzwiekowych.
 j=0

 #Dlugosc wycinka stringu.
 k=80

 while [ ${i} -lt ${SIZE} ]
 do
  l=$((i + k - 1))
  ll=$((i + k))

  if [ "${A:${l}:1}" != " " ] && [ ${ll} -ne ${SIZE} ]
  then
   #echo ${A:${l}:1}

   k=$((k - 1))
   continue
  fi

  #echo ${A:${i}:${k}}

  B=`echo ${A:${i}:${k}} | perl -MURI::Escape -lne 'print uri_escape($_);'`

  wget -q -O out${j}.mp3 --no-check-certificate --no-cookies --header "user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.91 Safari/537.36" "https://translate.google.pl/translate_tts?ie=UTF-8&q=${B}&tl=pl" &> /dev/null

  j=$((j + 1))
  i=$((i + ${k}))

  k=80
 done

 ffmpeg -i "concat:`ls out*.mp3 2> /dev/null | sort -V -f | tr '\n' '|' | sed -r -e 's/\|$//g'`" -acodec copy output.mp3

 if [ `echo "${@: -1}" | egrep "^[1-9][0-9]*$" | wc -l` -eq 1 ]
 then
  mpg123 --loop "${@: -1}" -a default -d 8 -h 10 output.mp3
 else
  mpg123 -a default -d 8 -h 10 output.mp3
 fi

 rm -rf out*.mp3
else
 echo "[ ERROR ]: No internet connection!" > /dev/stderr
fi


exit 0
