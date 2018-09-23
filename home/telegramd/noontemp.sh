#!/bin/bash
temp12="`head /home/telegramd/temperature`"
pressure="`/home/telegraf/pressure`"
humidity="`/home/telegraf/humidity`"
temp_out="`/home/telegraf/temperature_out`"
#echo $temp12
#echo $temp_out
for i in { 1..20 }
 do
curl -s --socks5 telegram.vpn99.net:55655 -i "https://api.telegram.org/$bot_token/sendMessage?chat_id=-165156279&text=Температура: $temp12; На улице: $temp_out; Давление: $pressure; Влажность: $humidity"
retval=$?
echo $retval
if [ "$retval" -eq 0 ] ; then 
break; 
fi
sleep 1
done


#curl -s -v -i "https://api.telegram.org/$bot_token/sendMessage?chat_id=-165156279&text=$pressure"
