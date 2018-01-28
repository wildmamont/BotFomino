#!/bin/bash
CAMERA_IP='vstarcamW'
rm /home/telegramd/video-* > /dev/null
curl -s -Y 1000000 -s -y 3 -o /home/telegramd/video-livestream.h264 "http://$CAMERA_IP:81/livestream.cgi?user=admin&pwd=888888&streamid=0"
#avconv -loglevel debug -vsync passthrough -f h264 -i /home/telegramd/video-livestream.h264 -f image2 /home/telegramd/video-photo%03d.jpg
avconv -vsync passthrough -f h264 -i /home/telegramd/video-livestream.h264 -f image2 /home/telegramd/video-photo%03d.jpg > /dev/null 2>&1
mv /home/telegramd/video-photo002.jpg /home/telegramd/video-photo.jpg > /dev/null
#echo video-photo.jpg
