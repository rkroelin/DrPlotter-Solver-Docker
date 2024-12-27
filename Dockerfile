# Use the base image
FROM ghcr.io/foxypool/drplotter:1.0.4-solver

# Set environment variables to suppress prompts
ENV DEBIAN_FRONTEND=noninteractive

# Add /app to PATH
ENV PATH="/app:$PATH"

# Declare environment variables (defaults are empty)
ENV DRSERVER_IP_ADDRESS=""
ENV DRPLOTTER_CLIENT_TOKEN=""

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    nano \
    proxychains \
    iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Configure Proxychains
RUN sed -i '/^socks4/d' /etc/proxychains.conf && \
    sed -i '/^socks5/d' /etc/proxychains.conf && \
    echo "socks5  127.0.0.1 1055" >> /etc/proxychains.conf

# Add entrypoint script
RUN echo '#!/bin/bash\n\
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &\n\
sleep 2\n\
tailscale up --authkey=${TAILSCALE_AUTHKEY}\n\
if [ -z "${DRSERVER_IP_ADDRESS}" ]; then\n\
  echo "Warning: DRSERVER_IP_ADDRESS is not set!"\n\
else\n\
  SERVER_IP=$(echo "${DRSERVER_IP_ADDRESS}" | cut -d ":" -f1)\n\
  echo "DrServer IP set in environment variable DRSERVER_IP_ADDRESS: ${DRSERVER_IP_ADDRESS}"\n\
  echo "Extracted Server IP (without port): ${SERVER_IP}"\n\
fi\n\
if [ -z "${DRPLOTTER_CLIENT_TOKEN}" ]; then\n\
  echo "Warning: DRPLOTTER_CLIENT_TOKEN is not set!"\n\
else\n\
  echo "DrPlotter Client Token: ${DRPLOTTER_CLIENT_TOKEN}"\n\
fi\n\
echo "Checking Tailscale status for DrServer (${SERVER_IP}):"\n\
if [ ! -z "${SERVER_IP}" ]; then\n\
  tailscale status | grep "${SERVER_IP}" || echo "DrServer (${SERVER_IP}) not found in Tailscale status."\n\
else\n\
  echo "Skipping Tailscale status check as SERVER_IP is not set."\n\
fi\n\
if [ ! -z "${SERVER_IP}" ]; then\n\
  echo "Pinging DrServer via Tailscale:"\n\
  tailscale ping ${SERVER_IP}\n\
  echo "Testing connection to ${SERVER_IP} via proxychains (ping):"\n\
  proxychains ping -c 4 ${SERVER_IP}\n\
else\n\
  echo "Skipping ping tests as SERVER_IP is not set."\n\
fi\n\
echo "Testing public IP visibility via proxychains (curl):"\n\
proxychains curl http://ifconfig.me\n\
echo "Testing DrSolver connection via proxychains:"\n\
PROXYCHAINS_DEBUG=1 proxychains drsolver --cli-only "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh