#!/bin/bash
PROGRAM=/bin/echo
MESSAGES=/opt/modem/messages.txt
sms_spool=/opt/modem/new_sms.txt
date >> $MESSAGES
set >> $MESSAGES
echo SMS From $SMS_1_NUMBER >$sms_spool
telegram_lua_script () {
echo "$@" >> $sms_spool
return 0
}

if [ "a${DECODED_0_TEXT}" != "a" ]; then
echo $DECODED_0_TEXT >> $sms_spool
else
for i in `seq $SMS_MESSAGES` ; do
eval "$PROGRAM \"\${SMS_${i}_TEXT}\"" >> $sms_spool
done
fi

if [ "$SMS_1_NUMBER" == "+79214202580" ] && [ "${SMS_1_TEXT:0:7}" == "tlg_cmd" ]; then
telegram_lua_script "${SMS_1_TEXT:8}";

cat /var/lib/telegram-daemon/script-achat.lua.backup > /var/lib/telegram-daemon/script-achat.lua
echo script-achat.lua reseted >> $sms_spool
fi

/opt/modem/sms2tg.sh
