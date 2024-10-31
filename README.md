# Turtle Web Monitor

A web-based interface for monitoring ROS2 turtlesim velocity data in real-time using Docker and WebSocket.

## Features
- Real-time visualization of turtlesim's cmd_vel topic data
- Web-based interface showing linear and angular velocities
- Docker containerized for easy setup and deployment

## Prerequisites
- Docker
- Web browser
- X Server (for Windows)

## Setup and Usage

1. Build the Docker image:
```bash
docker build -t ros2-turtle-monitor .
```

2. Run the container:
```bash
docker run -it --name ros2_turtle_monitor -e DISPLAY=host.docker.internal:0.0 -p 8081:8081 ros2-turtle-monitor node websocket_server.js
```

3. In a new terminal, connect to the container for turtle control:
```bash
docker exec -it ros2_turtle_monitor bash
source /opt/ros/humble/setup.bash
ros2 run turtlesim turtle_teleop_key
```

4. Open the web interface:
- Open your web browser
- Navigate to: http://localhost:8081

5. Control the turtle:
- Use arrow keys in the terminal running turtle_teleop_key
- Watch the velocity values update in real-time on the web interface

## Project Structure
- `Dockerfile`: Container configuration
- `websocket_server.js`: WebSocket server and ROS2 bridge
- `index.html`: Web interface
- `package.json`: Node.js dependencies
- `entrypoint.sh`: Container entry point script