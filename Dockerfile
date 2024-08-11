# Dockerfile for Guacamole image
#
# This Dockerfile sets up a standard Guacamole container that you can use
# inside your docker compose projects or standalone.
#
FROM guacamole/guacamole:1.5.5

# Run as root
USER root

# Tools for healthcheck
# Oly install what I'll need, i.e.: openssl netcat-openbsd curl.
RUN apt-get update && apt install -y curl

# Copy healthcheck
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

# Run as guacamole
USER guacamole

