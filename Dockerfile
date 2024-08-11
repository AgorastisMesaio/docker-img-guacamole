# Dockerfile for Guacamole image
#
# This Dockerfile sets up a standard Guacamole container that you can use
# inside your docker compose projects or standalone.
#
FROM guacamole/guacamole:1.5.5

# This image is based on Ubuntu and has curl installed...
ADD healthcheck.sh /opt/guacamole/healthcheck.sh
RUN chmod +x /opt/guacamole/healthcheck.sh

# My custom health check
# I'm calling /healthcheck.sh so my container will report 'healthy' instead of running
# --interval=30s: Docker will run the health check every 'interval'
# --timeout=10s: Wait 'timeout' for the health check to succeed.
# --start-period=3s: Wait time before first check. Gives the container some time to start up.
# --retries=3: Retry check 'retries' times before considering the container as unhealthy.
HEALTHCHECK --interval=30s --timeout=10s --start-period=3s --retries=3 \
  CMD /opt/guacamole/healthcheck.sh || exit $?


