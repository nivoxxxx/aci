FROM eclipse-mosquitto:latest

RUN apk update && apk add openjdk8
RUN mkdir -p /srv/www/tracking


RUN echo -e "\nlistener 1883 0.0.0.0\nallow_anonymous true" >> /mosquitto/config/mosquitto.conf
EXPOSE 1883

COPY rt_mqtt /rt_mqtt
COPY tracking /tracking
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD ["/startup.sh"]