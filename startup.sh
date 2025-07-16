#!/bin/sh

# Function to start all services
start_services() {
    crond -n &
    /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf &
    echo "Starting services..."
    # Start the first Java process in background
    cd /tracking
    java -jar trakingServer.jar server_40028.conf 1> /srv/www/tracking/log40028.log 2> /srv/www/tracking/log40028.log &
    java -jar trakingServer.jar server_40022.conf 1> /srv/www/tracking/log40022.log 2> /srv/www/tracking/log40022.log &

    # Start the second Java process in background
    cd /rt_mqtt
    java -XX:+UseSerialGC -jar CollectorRTMQTT.jar 1>> /srv/www/tracking/log_succcess_rtm.log 2>> /srv/www/tracking/log_err_rtm.log &

    cd /path
    java -XX:+UseSerialGC -jar PathCollector.jar 1>> /srv/www/tracking/log_success_path.log 2>> /srv/www/tracking/log_err_path.log &

    # Keep the container running (important!)
    tail -f /dev/null
}

# Function to stop all services (except mosquitto)
stop_services() {
    echo "Stopping services..."
    # Find and kill all java processes (except mosquitto)
    pids=$(pgrep -f "java.*(CollectorRTMQTT.jar|PathCollector.jar)")
    if [ -n "$pids" ]; then
        kill $pids
        echo "Stopped Java services"
    else
        echo "No Java services running"
    fi
}

restart_services() {
    echo "Stopping services..."
    stop_services
    sleep 1  # Brief pause between stop and start

    echo "Starting services..."


    # Start the second Java process in background
    cd /rt_mqtt
    java -XX:+UseSerialGC -jar CollectorRTMQTT.jar 1>> /srv/www/tracking/log_succcess_rtm.log 2>> /srv/www/tracking/log_err_rtm.log &

    cd /path
    java -XX:+UseSerialGC -jar PathCollector.jar 1>> /srv/www/tracking/log_success_path.log 2>> /srv/www/tracking/log_err_path.log &

}


# Handle command line arguments
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    *)
        # If no argument or unknown argument, run as is (original behavior)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
