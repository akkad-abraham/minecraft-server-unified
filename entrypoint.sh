#!/bin/bash

# Make sure the EULA agreement is set to true
if [ "$EULA" = "true" ]; then
    echo "eula=true" > eula.txt
else
    echo "You must accept the Minecraft EULA by setting the EULA environment variable to true."
    exit 1
fi

# Set default value for minecraft vanilla version to latest release
MC_VERSION=${MC_VERSION:-$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release')}

# Set Java version based on Minecraft version if not provided
if [[ -z "$JAVA_VERSION" ]]; then
    if [ "$(echo -e "$MC_VERSION\n1.21" | sort -V | head -n1)" = "$MC_VERSION" ]; then
        JAVA_VERSION=17
    else
        JAVA_VERSION=21
    fi
fi

# Set the Java version based on JAVA_VERSION environment variable
case $JAVA_VERSION in
    17)
        JAVA_BIN="/usr/lib/jvm/java-17-openjdk-amd64/bin/java"
        ;;
    21)
        JAVA_BIN="/usr/lib/jvm/java-21-openjdk-amd64/bin/java"
        ;;
    *)
        echo "Unsupported Java version: $JAVA_VERSION"
        exit 1
        ;;
esac

# Set default values for Java memory options if not provided
JAVA_XMX=${JAVA_XMX:-2G}
JAVA_XMS=${JAVA_XMS:-2G}

# Allow users to provide additional Java arguments
JAVA_ARGS="-Xmx$JAVA_XMX -Xms$JAVA_XMS ${JAVA_ARGS:-}"

# Set default value for mod loader to vanilla
MOD_LOADER=${MOD_LOADER:-vanilla}

# Check if the server is already installed (using start.sh as an indicator)
if [ ! -f "start.sh" ]; then
    echo "Installing Minecraft server..."

    if [ "$MOD_LOADER" = "vanilla" ]; then
        # Install vanilla Minecraft server
        MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"
        VERSION_JSON_URL=$(curl -s $MANIFEST_URL | jq -r ".versions[] | select(.id == \"$MC_VERSION\") | .url")
        SERVER_URL=$(curl -s $VERSION_JSON_URL | jq -r ".downloads.server.url")
        wget $SERVER_URL -O server.jar
        # TODO Add support for custom launch arguments
        echo "$JAVA_BIN $JAVA_ARGS -jar server.jar nogui" > start.sh
        chmod +x start.sh

    elif [ "$MOD_LOADER" = "forge" ]; then
        # Install Forge server
        FORGE_URL="https://files.minecraftforge.net/maven/net/minecraftforge/forge/$MC_VERSION-$MOD_LOADER_VERSION/forge-$MC_VERSION-$MOD_LOADER_VERSION-installer.jar"
        wget $FORGE_URL -O forge-installer.jar
        java -jar forge-installer.jar --installServer
        rm forge-installer.jar
        # Use the default run.sh as a template for start.sh for newer versions of Forge
        # For older versions Forge jar name follows the pattern forge-<mc_version>-<forge_version>.jar
        if [ -f "user_jvm_args.txt" ]; then
            echo "$JAVA_ARGS" > user_jvm_args.txt
            # TODO: FIX: run.sh uses the system java which can have other version than the one needed!
            echo "./run.sh nogui" > start.sh
        else
            echo "$JAVA_BIN $JAVA_ARGS -jar forge-$MC_VERSION-$MOD_LOADER_VERSION.jar nogui" > start.sh
        fi
        chmod +x start.sh

    elif [ "$MOD_LOADER" = "fabric" ]; then
        # Install Fabric server
        FABRIC_INSTALLER_URL="https://meta.fabricmc.net/v2/versions/loader/$MC_VERSION/$MOD_LOADER_VERSION/$FABRIC_INSTALLER_VERSION/server/jar"
        wget $FABRIC_INSTALLER_URL -O fabric-installer.jar
        echo "$JAVA_BIN $JAVA_ARGS -jar fabric-installer.jar nogui" > start.sh
        chmod +x start.sh

    # Add NeoForge support (similar to Forge, adjust URL as needed)
    elif [ "$MOD_LOADER" = "neoforge" ]; then
        NEFORGE_URL="https://maven.neoforged.net/releases/net/neoforged/neoforge/$MOD_LOADER_VERSION/neoforge-$MOD_LOADER_VERSION-installer.jar"
        wget $NEFORGE_URL -O neoforge-installer.jar
        java -jar neoforge-installer.jar --installServer
        rm neoforge-installer.jar
        # TODO: FIX Execution
        echo "$JAVA_BIN -Xmx$JAVA_XMX -Xms$JAVA_XMS -jar neoforge-$MOD_LOADER_VERSION.jar nogui" > start.sh
        chmod +x start.sh

    else
        echo "Unsupported mod loader: $MOD_LOADER"
        exit 1
    fi
fi

# Start the server inside a screen session
exec screen -S minecraft ./start.sh