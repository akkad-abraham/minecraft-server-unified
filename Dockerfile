# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install required packages: Java 17, Java 21, wget, and jq for parsing JSON (e.g., Minecraft version manifest)
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    openjdk-21-jdk \
    wget \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for running the server (UID 1000 is typical for first user on Ubuntu)
RUN useradd -m -u 1000 minecraft

# Set the working directory inside the container
WORKDIR /server

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to the minecraft user
USER minecraft

# Define the entrypoint to run the script
ENTRYPOINT ["/entrypoint.sh"]