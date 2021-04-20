# free_chat

A proof-of-concept of running a chat application over the Freenet.

This application implements an FCP library in Dart, which you can find under lib/src/fcp.
It is nowhere complete but offers the foundation to finishing the library.


# Workflow
1. The first user creates an initial invite consisting of a handshakeUri (Unique KSK key) and a requestUri (USK key) and shares it via QR code with the chat partner
2. The second user creates an invite response with their USK key and uploads it to the handshakeUri, and subscribes to the requestUri
3. The first user checks for an invite response on the handshakeUri and also subscribes to the requestUri of the second user
4. On message send the chat document on the requestUri gets updated
5. As soon as a user gets notified by the usk subscription it downloades the newest chat and resolves the deltas with the local chat to always have the newest

# Demo
You can find a demo of the application [here](https://youtu.be/BP_sBDDAPgU)

# Pain points
- The ClientPut takes way too long (especially on the initial handshake, which can take over 10 minutes).
- There are a couple of Failed Errors I don't quite get how to fix, eg. "Not enough data" (28) found with it the "A node killed the request because it had recently been tried and had DNFed" (30)

# Sources
[https://flutter.dev/](https://flutter.dev/): Used to create the frontend of the application
[Freenet-Mobile](https://github.com/freenet-mobile/app): Needed to run a Freenet node on the smartphone, which is used to chat
[jFCPlib](https://github.com/Bombe/jFCPlib): As an inspiration for writing the FCP wrapper in Dart
[FCPv2](https://github.com/freenet/wiki/wiki/FCPv2): Used to create the FCP wrapper