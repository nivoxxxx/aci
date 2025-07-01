# Start with the official Mosquitto image
FROM eclipse-mosquitto:2.0.21-openssl

# Install OpenJDK 8, logrotate and cron
RUN apk update && apk add openjdk8 logrotate cronie

# Create a directory for your files
RUN mkdir -p /srv/www/tracking

# Configure Mosquitto
RUN echo -e "\nlistener 1883 0.0.0.0\nallow_anonymous true" >> /mosquitto/config/mosquitto.conf
EXPOSE 1883

# Copy your files into the container
COPY rt_mqtt /rt_mqtt
COPY tracking /tracking
COPY path /path

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

# Configure logrotate for Mosquitto
RUN mkdir -p /etc/logrotate.d
COPY collectors /etc/logrotate.d/collectors
RUN chmod 644 /etc/logrotate.d/collectors

# Create cron job to run startup.sh every hour
RUN echo "0 * * * * /startup.sh restart " >> /etc/crontabs/root
RUN echo "*/10 * * * * logrotate  /etc/logrotate.d/collectors" >> /etc/crontabs/root
#RUN echo "* * * * * logrotate  /etc/logrotate.d/collectors" >> /etc/crontabs/root



# Copy and make the startup script executable
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
# Run cron in foreground and startup script
CMD ["/startup.sh",  "start"]
