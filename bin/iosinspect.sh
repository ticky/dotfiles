echo "Mobile Safari Remote Inspector"
echo "------------------------------"
MobileSafari_PID=$(ps x | grep "MobileSafari" | grep -v grep | awk '{ print $1 }')

if [ "$MobileSafari_PID" == "" ]; then

	echo "Safari doesn't appear to be running. Opening iOS Simulator for you..."
	open "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app"
	echo "Please launch Safari on your iOS simulator then press return."
	read

	while [ "$MobileSafari_PID" == "" ]; do
		MobileSafari_PID=$(ps x | grep "MobileSafari" | grep -v grep | awk '{ print $1 }')
	done
fi

echo "Mobile Safari process found! Enabling Remote Inspector on MobileSafari...."
cat <<EOM | gdb -quiet > /dev/null
attach $MobileSafari_PID
p (void *)[WebView _enableRemoteInspector]
detach
EOM

echo "Opening Remote Inspector panel in your default browser..."

open "http://localhost:9999/"

echo "Done."