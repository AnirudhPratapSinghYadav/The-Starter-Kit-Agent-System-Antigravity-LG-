---
name: Liquid Galaxy SSH Skill
description: Best practices for handling SSH connections in Liquid Galaxy applications using dartssh2.
---

# Liquid Galaxy SSH Skill

## Overview
Liquid Galaxy rigs typically consist of a Master node and multiple Slave nodes running on a local network (192.168.x.x). SSH is the primary communication protocol.

## Connection Best Practices
1.  **Library**: Always use `dartssh2`.
2.  **Timeout**: Set a connection timeout (e.g., 5 seconds) to prevent UI hangs.
3.  **Authentication**: Support both Password and Key-based authentication (though Password is standard for LG rigs).
4.  **Persistence**: Maintain the `SSHClient` instance in a Provider/Service to reuse the socket.

## Command Execution
-   **KML Upload**: Use `echo 'content' > /var/www/html/kmls/filename.kml` or `scp`.
-   **Refresh**: Update slave screens by modifying `drivers.kml` or syncing `kmls.txt`.
-   **Clean**: To clear the screen, send an empty KML structure.
-   **Reboot**: `echo password | sudo -S reboot`.

## Error Handling
-   Wrap connection attempts in `try-catch`.
-   If `socket` fails, check if the IP is reachable.
-   Gracefully handle `SocketException`.

## Example
```dart
final socket = await SSHSocket.connect(host, port, timeout: Duration(seconds: 5));
final client = SSHClient(socket, username: user, onPasswordRequest: () => password);
```
