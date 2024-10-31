const rclnodejs = require('rclnodejs');
const WebSocket = require('ws');
const http = require('http');
const fs = require('fs');
const path = require('path');

// Create HTTP server
const server = http.createServer((req, res) => {
    if (req.url === '/') {
        fs.readFile(path.join(__dirname, 'index.html'), (err, data) => {
            if (err) {
                res.writeHead(500);
                res.end('Error loading index.html');
                return;
            }
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.end(data);
        });
    }
});

// Initialize ROS2 node and WebSocket server
rclnodejs.init().then(() => {
    const node = new rclnodejs.Node('turtle_websocket_bridge');
    
    // Create WebSocket server attached to HTTP server
    const wss = new WebSocket.Server({ server });
    
    // Subscribe to turtle1's cmd_vel topic
    const subscription = node.createSubscription(
        'geometry_msgs/msg/Twist',
        '/turtle1/cmd_vel',
        (msg) => {
            if (wss.clients.size > 0) {
                wss.clients.forEach((client) => {
                    if (client.readyState === WebSocket.OPEN) {
                        client.send(JSON.stringify(msg));
                    }
                });
            }
        }
    );

    console.log('WebSocket server initialized');
    node.spin();
});

// Start server on all network interfaces
server.listen(8081, '0.0.0.0', () => {
    console.log('Server running at http://0.0.0.0:8081');
});