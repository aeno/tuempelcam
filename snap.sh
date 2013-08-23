HOUR=$(date +"%H")
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
NOWHUMAN=$(date +"%Y-%m-%d %H:%M:%S")
LOGFILE="/home/pi/tuempelcam/log/$NOW.log"

echo "Snapshotting at $NOWHUMAN" 1>> $LOGFILE

if [$HOUR -ge 6 -a $HOUR -lt 20]; then
	v4l2-stl --set-ctrl brightness=90
	v4l2-stl --set-ctrl contrast=35
	v4l2-stl --set-ctrl saturation=45
	v4l2-stl --set-ctrl white_balance_temperature_auto=0
	v4l2-stl --set-ctrl gain=80
	v4l2-stl --set-ctrl white_balance_temperature=7560
	v4l2-stl --set-ctrl sharpness=50
	v4l2-stl --set-ctrl exposure_auto=1
	v4l2-stl --set-ctrl exposure_absolute=3
	v4l2-ctl --set-ctrl exposure_absolute=3
fi

CAMSETTINGS=$(v4l2-ctl --list-ctrls)

echo "Using Settings:" 1>> $LOGFILE
echo $CAMSETTINGS 1>> $LOGFILE

uvccapture -S45 -B90 -C35 -G80 -x1280 -y960 -o"/home/pi/tuempelcam/$NOW.jpg"
sleep 2
uvccapture -S45 -B90 -C35 -G80 -x1280 -y960 -o"/home/pi/tuempelcam/$NOW.jpg"
cp -f -T "/home/pi/tuempelcam/$NOW.jpg" "/home/pi/tuempelcam/last.jpg"
flickcurl upload "/home/pi/tuempelcam/last.jpg" title "$NOW" description "View of the pond at $NOWHUMAN, camera settings: $CAMSETTINGS" public tags "webcam, schwerin, pond, tuempel" 1>> $LOGFILE

echo "Done." 1>> $LOGFILE

