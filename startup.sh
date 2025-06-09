#!/bin/sh
/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf &

# Start the first Java process in background

cd /tracking
java -jar trakingServer.jar server_40028.conf 1> /srv/www/tracking/log40028.log 2> /srv/www/tracking/log40028.log &

# Start the second Java process in background
cd /rt_mqtt
java -XX:+UseSerialGC -jar CollectorRTMQTT.jar 1>> /srv/www/tracking/log_success_rtm.log 2>> /srv/www/tracking/log_err_rtm.log &

cd /path
java -XX:+UseSerialGC -jar PathCollector.jar 1>> /srv/www/tracking/log_success_path.log 2>> /srv/www/tracking/log_err_path.log &

# Keep the container running (important!)
tail -f /dev/null
