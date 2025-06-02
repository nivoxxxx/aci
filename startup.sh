#!/bin/sh
/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf &

# Start the first Java process in background

cd /tracking
java -jar trakingServer_out.jar server_40028.conf 1> /srv/www/tracking/log40028.log 2> /srv/www/tracking/log40028.log &

# Start the second Java process in background
cd /rt_mqtt
java -XX:+UseSerialGC -jar CollectorRTMQTT_out.jar 1>> /srv/www/tracking/log_succcess_rtm.log 2>> /srv/www/tracking/log_err_rtm.log &

# Keep the container running (important!)
tail -f /dev/null
