FROM ros:humble

# Install Node.js 18.x and npm
RUN apt-get update && apt-get install -y \
    curl \
    ros-humble-turtlesim \
    python3-pip \
    python3-colcon-common-extensions \
    build-essential \
    python3-rosdep

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Update rosdep only (skip init since it's already initialized)
RUN rosdep update

# Verify Node.js and npm installation
RUN node --version && npm --version

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json .

# Source ROS2 environment and install dependencies
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    echo $AMENT_PREFIX_PATH && \
    npm install"

# Copy application files
COPY websocket_server.js .
COPY index.html .

# Set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]