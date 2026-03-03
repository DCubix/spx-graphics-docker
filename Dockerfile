# Use Node.js 18 LTS slim image as the base
FROM node:18-slim

LABEL org.opencontainers.image.description="SPX Graphics is a free and open-source live graphics control application, designed by Tuomo for graphics enthusiasts in the fields of broadcast, streaming, and events production."

# Set the working directory in the container
WORKDIR /SPX

# Install necessary packages: wget to download the source tarball
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download and extract the SPX v.1.3.0 source from GitHub
RUN wget -O spx.tar.gz https://github.com/TuomoKu/SPX-GC/archive/refs/tags/v.1.3.0.tar.gz && \
    tar -xzf spx.tar.gz --strip-components=1 && \
    rm spx.tar.gz

# Install production dependencies
RUN npm install --production

# Create directories for logs and configuration
RUN mkdir -p /SPX/LOG /SPX/ASSETS/CONFIG

COPY start-spx.sh /SPX/start-spx.sh
COPY default-config.json /SPX/ASSETS/CONFIG/default-config.json

# Ensure start-spx.sh is executable
RUN chmod +x /SPX/start-spx.sh

EXPOSE 5656

# Define volumes for logs and configuration
VOLUME ["/SPX/LOG", "/SPX/ASSETS"]

# Run SPX, using start script with custom config file
CMD ["/SPX/start-spx.sh"]

