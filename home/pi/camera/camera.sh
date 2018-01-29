#!/bin/bash
CAMERA_IP='vstarcamW'
rm /home/telegramd/video-livestream.h264 > /dev/null
rm /home/telegramd/video-photo001.jpg /home/telegramd/video-photo003.jpg > /dev/null
curl -s -Y 1000000 -s -y 3 -o /home/telegramd/video-livestream.h264 "http://192.168.66.133:81/livestream.cgi?user=admin&pwd=888888&streamid=0"
avconv  -vsync passthrough -f h264 -i /home/telegramd/video-livestream.h264  -f image2 /home/telegramd/video-photo%03d.jpg  > /dev/null 2>&1
mv /home/telegramd/video-photo002.jpg /home/telegramd/video-photo.jpg > /dev/null

