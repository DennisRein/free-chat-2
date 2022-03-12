# free_chat

A proof-of-concept of running a chat application over the Freenet.

This application implements an FCP library in Dart, which you can find under lib/src/fcp.
It is nowhere complete but offers the foundation to finishing the library.

# Usecase
[Covers the needs for protection expected from a secure data broker for Multi-Party Data Exchange in IoT for Health](https://www.igi-global.com/chapter/using-freenet-as-a-broker-for-multi-party-data-exchange-in-iot-for-health/257911)

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
  - Directly send an SSK private key to get rid of one round-trip and enable cheaper USK subscription to get the connection.
- There are a couple of Failed Errors I don't quite get how to fix, eg. "Not enough data" (28) found with it the "A node killed the request because it had recently been tried and had DNFed" (30)
- ShortCodeDescription=Too many path components error (RedirectURI=USK@MPfWVX5LRsV4Kydc7MZz~Dz-SF2vsACubh254FhGQf0,mscpVYfGntiupHWVzdc4CTa-VLjABC9MXGYYri8M~fc,AQACAAE/chat/2)
- After successful connection, the UI should directly switch to the Chats view
- Desktop: Pressing Enter in a Chat should send the message
- Enable setting IP and Port for the FCMP connection

# Dependencies

- OpenJDK 15
- clang
- cmake
- ninja-build-dev
- pkg-config
- gtk (lib-gtk-3)
- xz (liblzma)
- mesa (libEGL) 
- wayland
- libx11
- pthread, libdl (gcc-toolchain)


## Guix

Put this as `env.sh` in the flutter source folder (from `git clone https://github.com/flutter/flutter.git`):

    #!/usr/bin/env bash
    export PATH="$PATH:"$(dirname "$(realpath "$0")")"/bin"
    export CHROME_EXECUTABLE=$(which chromium)
    # need to track libstdc++ in the dependencies of the GCC toolchain
    GCC_TOOLCHAIN="gcc-toolchain"
    GCC_LIB_PATH="$(grep -oE "[^\"]*gcc-[^\"]*-lib" $(grep -oE "[^\"]*gcc-[^\"]*drv" $(guix build -d ${GCC_TOOLCHAIN})) | head -n 1)"
    export LD_LIBRARY_PATH="${GCC_LIB_PATH}/lib"
    # flutter config --enable-linux-desktop
    # exec -a flutter-guix-shell 
    guix shell clang cmake ninja pkg-config gtk gtk+ xz mesa wayland libx11 gcc-toolchain libpthread-stubs sqlite -- flutter doctor
    guix shell clang cmake ninja pkg-config gtk gtk+ xz mesa wayland libx11 gcc-toolchain libpthread-stubs sqlite

# Build or run

## Guix

Build an android release:

    guix shell openjdk@15 -- flutter build apk

Start free-chat-2:

    cd path/to/free-chat-2 && /path/to/flutter/env.sh # see dependencies
    # in the opening shell
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${GUIX_ENVIRONMENT}/lib flutter run [--release]

If you run multiple nodes, use `--release` for the second and further nodes. They need to be started in their own shell processes.

# Sources
- [https://flutter.dev/](https://flutter.dev/): Used to create the frontend of the application
- [Freenet-Mobile](https://github.com/freenet-mobile/app): Needed to run a Freenet node on the smartphone, which is used to chat
- [jFCPlib](https://github.com/Bombe/jFCPlib): As an inspiration for writing the FCP wrapper in Dart
- [FCPv2](https://github.com/freenet/wiki/wiki/FCPv2): Used to create the FCP wrapper
