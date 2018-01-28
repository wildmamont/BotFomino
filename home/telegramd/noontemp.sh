#!/bin/bash
temp12="`head /home/telegramd/temperature`"
pressure="`/home/telegraf/pressure`"
humidity="`/home/telegraf/humidity`"
#echo $temp12
curl -s -i "https://api.telegram.org/$bot_token/sendMessage?chat_id=-165156279&text=Температура: $temp12; Давление: $pressure; Влажность: $humidity"
#curl -i "https://api.telegram.org/$bot_token/sendMessage?chat_id=-165156279&text=$pressure"
