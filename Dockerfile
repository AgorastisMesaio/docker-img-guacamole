# Dockerfile for Guacamole CLIENT image
#
# This Dockerfile sets up a standard Guacamole container that you can use
# inside your docker compose projects or standalone.
#
FROM guacamole/guacamole:latest
#1.5.5

# Prepare for healthcheck
USER root
#RUN apt-get update

# Adding HEALTHCHECK support.
#
# This image is based on Ubuntu and has curl installed, adding
# a script under guacamole installation directory
ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# My custom health check
# I'm calling /healthcheck.sh so my container will report 'healthy' instead of running
# --interval=30s: Docker will run the health check every 'interval'
# --timeout=10s: Wait 'timeout' for the health check to succeed.
# --start-period=3s: Wait time before first check. Gives the container some time to start up.
# --retries=3: Retry check 'retries' times before considering the container as unhealthy.
HEALTHCHECK --interval=30s --timeout=10s --start-period=3s --retries=3 \
  CMD /healthcheck.sh || exit $?

# Back to guacamole
USER guacamole

# # Environment variable defaults
# ENV BAN_ENABLED=true \
#     ENABLE_FILE_ENVIRONMENT_PROPERTIES=true \
#     GUACAMOLE_HOME=/etc/guacamole

# # Start Guacamole under Tomcat, listening on 0.0.0.0:8080
# EXPOSE 8080
# CMD ["/opt/guacamole/bin/entrypoint.sh" ]

