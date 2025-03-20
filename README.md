# Minecraft Modpack Server Docker Image

This Docker image allows you to easily set up and run a Minecraft server with support for various mod loaders, including Vanilla, Forge, Fabric, and NeoForge. The image is designed to be user-friendly and configurable through environment variables.

---

## How to Use

To use this Docker image, you need to set a few environment variables to configure the server. These variables control the version of Java, the Minecraft version, and the mod loader you want to use.

### Environment Variables

Here is a list of environment variables you can set, along with explanations of what they do:

### 1. `JAVA_VERSION`
- **Description**: Specifies the version of Java to use for running the Minecraft server.
- **Options**: `17` or `21`
- **Default**: None (must be set).
- **How to Set**: Add `-e JAVA_VERSION=17` or `-e JAVA_VERSION=21` when running the Docker container.  
- **Example**:  
```sh
  docker run -e JAVA_VERSION=17 ...
```

### 2. MC_VERSION
- **Description**: Specifies the version of Minecraft you want to run on the server.
- **Options**: Any valid Minecraft version (e.g., `1.20.1`, `1.19.4`).
- **Default**: None (must be set).
- **How to Set**: Add `-e MC_VERSION=1.20.1` when running the Docker container.
Example:
### 3. MOD_LOADER
- **Description**: Specifies the mod loader to use for the server.
- **Options**: :
  - `vanilla`: Runs a standard Minecraft server without mods.  
  - `forge`: Runs a Forge modded server.  
  - `fabric`: Runs a Fabric modded server.  
  - `neoforge`: Runs a NeoForge modded server.  
- **Default**: None (must be set).
- **How to Set**: Add `-e MOD_LOADER=forge` (or another option) when running the Docker container.
- **Example**:  
```sh
docker run -e MOD_LOADER=forge ...
```

### 4. MOD_LOADER_VERSION
- **Description**: Specifies the version of the mod loader to use. This is required if you are using `forge`, `fabric`, or `neoforge` as the mod loader.
- **Options**: : Any valid version of the selected mod loader (e.g., `45.0.66` for Forge, `0.14.21` for Fabric).
- **Default**: None (must be set if using a mod loader).
- **How to Set**: Add `-e MOD_LOADER_VERSION=45.0.66` when running the Docker container.
- **Example**:  
```sh
docker run -e MOD_LOADER_VERSION=45.0.66 ...
```

### Example Usage
Here is an example of how to run the Docker container with all the required environment variables:

```sh
docker run -d \
  -e JAVA_VERSION=17 \
  -e MC_VERSION=1.20.1 \
  -e MOD_LOADER=forge \
  -e MOD_LOADER_VERSION=45.0.66 \
  -v /path/to/server_data:/server \
  -p 25565:25565 \
  minecraft-modpack-server
```

**Additional Notes**  

- **EULA**: The server automatically accepts the Minecraft EULA by creating an `eula.txt` file with eula=true. By using this image, you agree to the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula).
- **Data Persistence**: Mount a volume to `/server` to persist server data across container restarts.
- **Logs**: Server logs are stored in the `/server` directory.  

**Troubleshooting**
- **Unsupported Java Version**: Ensure you set `JAVA_VERSION` to either `17` or `21`.
- **Unsupported Mod Loader**: Ensure you set `MOD_LOADER` to one of the supported options (`vanilla`, `forge`, `fabric`, `neoforge`).
- **Missing Environment Variables**: Make sure all required variables (`JAVA_VERSION`, `MC_VERSION`, `MOD_LOADER`, and `MOD_LOADER_VERSION` if applicable) are set.  
- **License**
This Docker image is provided under the **MIT License**. Minecraft is a trademark of Mojang AB, and this image is not affiliated with or endorsed by Mojang AB.