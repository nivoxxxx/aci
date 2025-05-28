FROM eclipse-mosquitto:latest

# Install OpenJDK 8
RUN apk update && apk add openjdk8
# Create a directory for your files
RUN mkdir -p /srv/www/tracking

# Copy your files into the container
COPY rt_mqtt /rt_mqtt
COPY tracking /tracking
# (Optional) Set environment variables if needed
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
# (Optional) Add any additional Mosquitto configuration
# COPY custom-mosquitto.conf /mosquitto/config/mosquitto.conf
# Copy and make the startup script executable
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Run the script when container starts
CMD ["/startup.sh"]

