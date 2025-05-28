#!/bin/sh
/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf &

# Start the first Java process in background
java -jar /tracking/trakingServer_out.jar server_40028.conf 1> /srv/www/tracking/log40028.log 2> /srv/www/tracking/log40028.log &

# Start the second Java process in background
java -XX:+UseSerialGC -jar /rt_mqtt/CollectorRTMQTT_out.jar 1>> /srv/www/tracking/log_succcess_rtm.log 2>> /srv/www/tracking/log_err_rtm.log &

# Keep the container running (important!)
tail -f /dev/null


