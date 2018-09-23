/home/pi/camera/camera.sh
for i in { 1..20}
 do
curl --socks5 telegram.vpn99.net:55655  -s -i -X POST -F photo=@/home/pi/camera/photo.jpg https://api.telegram.org/$bot_token/sendPhoto?chat_id=-165156279
retval=$?
echo $retval
if [ "$retval" -eq 0 ] ; then 
break; 
fi
sleep 1
done
/home/telegramd/noontemp.sh
