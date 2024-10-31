#!/bin/bash
set -e

# Source ROS2 environment
source /opt/ros/humble/setup.bash

# Start turtlesim node in the background
ros2 run turtlesim turtlesim_node &

# Set AMENT_PREFIX_PATH for rclnodejs
export AMENT_PREFIX_PATH="/opt/ros/humble"

# Start the WebSocket server
exec "$@"