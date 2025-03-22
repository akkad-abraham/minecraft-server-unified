# Minecraft Modpack Server Docker Image
This Docker image allows you to easily set up and run a Minecraft server with support for various mod loaders, including `Vanilla`, `Forge`, `Fabric`, and `NeoForge`. The image is designed to be user-friendly and configurable through environment variables. Additionally, it provides the ability to access and modify the server files directly from the host machine. This feature allows you to place your own mods, configurations, and other custom files into the server directory, ensuring a fully customizable experience. 

---

## How to Use

To use this Docker image, you need to set a few environment variables to configure the server. These variables control the version of Java, the Minecraft version, and the mod loader you want to use.


### Overview of Environment Variables

| Variable            | Description                                                                 | Options                                                                  | Default                      | Required |
|---------------------|-----------------------------------------------------------------------------|--------------------------------------------------------------------------|------------------------------|----------|
| `MC_VERSION`        | Specifies the version of Minecraft you want to run on the server.           | Any valid Minecraft version >= `1.17` (e.g., `1.20.1`, `1.19.4`)         | `latest-release`             | No       |
| `JAVA_VERSION`      | Specifies the version of Java to use for running the Minecraft server.      | `17`, `21`                                                               | `auto` (based on MC_VERSION) | No       |
| `MOD_LOADER`        | Specifies the mod loader to use for the server.                             | `vanilla`, `forge`, `fabric`, `neoforge`                                 | `vanilla`                    | No       |
| `MOD_LOADER_VERSION`| Specifies the version of the mod loader to use.                             | Any valid version of the selected mod loader (e.g., `47.4.0`, `0.14.21`)| None                         | Yes (if using a mod loader other than `vanilla`) |
| `JAVA_XMX`          | Specifies the maximum memory allocation for the JVM.                        | Any valid memory size (e.g., `2G`, `4G`)                                 | `2G`                         | No       |
| `JAVA_XMS`          | Specifies the initial memory allocation for the JVM.                        | Any valid memory size (e.g., `2G`, `4G`)                                 | `2G`                         | No       |
| `EULA`              | Specifies whether the use accepts [minecraft's eula agreement](https://account.mojang.com/documents/minecraft_eula)                        | Any valid memory size (e.g., `2G`, `4G`)                                 | `2G`                         | No       |
  
### Environment Variables

<details>
  <summary>See detailed guide on who to use these variables</summary>

  #### 1. `JAVA_VERSION`
  - **Description**: Specifies the version of Java to use for running the Minecraft server.
  - **Options**: `17` or `21`
  - **Default**: None (must be set).
  - **How to Set**: Add `-e JAVA_VERSION=17` or `-e JAVA_VERSION=21` when running the Docker container.  
  - **Example**:  
  ```sh
    docker run -e JAVA_VERSION=17 ...
  ```
  
  #### 2. `MC_VERSION`
  - **Description**: Specifies the version of Minecraft you want to run on the server.
  - **Options**: Any valid Minecraft version (e.g., `1.20.1`, `1.19.4`).
  - **Default**: latest-release
  - **How to Set**: Add `-e MC_VERSION=1.20.1` when running the Docker container.
  - **Example**:  
  ```sh
    docker run -e MC_VERSION=1.20.1 ...
  ```
  
  #### 3. `MOD_LOADER`
  - **Description**: Specifies the mod loader to use for the server.
  - **Options**: :
    - `vanilla`: Runs a standard Minecraft server without mods.  
    - `forge`: Runs a Forge modded server.  
    - `fabric`: Runs a Fabric modded server.  
    - `neoforge`: Runs a NeoForge modded server.  
  - **Default**: `vanilla`
  - **How to Set**: Add `-e MOD_LOADER=forge` (or another option) when running the Docker container.
  - **Example**:  
  ```sh
  docker run -e MOD_LOADER=forge ...
  ```
  
  #### 4. `MOD_LOADER_VERSION`
  - **Description**: Specifies the version of the mod loader to use. This is required if you are using `forge`, `fabric`, or `neoforge` as the mod loader.
  - **Options**: : Any valid version of the selected mod loader (e.g., `47.4.0` for Forge, `0.14.21` for Fabric).
  - **Default**: None (must be set if using a mod loader).
  - **How to Set**: Add `-e MOD_LOADER_VERSION=47.4.0` when running the Docker container.
  - **Example**:  
  ```sh
  docker run -e MOD_LOADER_VERSION=47.4.0 ...
  ```
  
  #### 5. `JAVA_XMX` and `JAVA_XMS`
  - **Description**: Specifies the maximum (`JAVA_XMX`) and initial (`JAVA_XMS`) memory allocation for the Java Virtual Machine (JVM). These variables control how much memory the Minecraft server can use.
  - **Default**: `JAVA_XMX=4G`, `JAVA_XMS=4G`
  - **How to Set**: Add `-e JAVA_XMX=2G -e JAVA_XMS=2G` (or other values) when running the Docker container.
  - **Example**:  
  ```sh
  docker run -e JAVA_XMX=2G -e JAVA_XMS=2G ...
  ```
</details>


### Example Usage
Here is an example of how to run the Docker container with all the required environment variables:

> **! Important**: Make sure to replace `/path/to/server_data` with a path to an already existing folder in the host machine.

```bash
docker run -it --name my-minecraft-server -e JAVA_VERSION=17 -e MC_VERSION=1.20.1 -e MOD_LOADER=forge -e MOD_LOADER_VERSION=47.4.0 -e JAVA_XMX=2G -e JAVA_XMS=2G -v /path/to/server_data:/home/minecraft/server -p 25565:25565 minecraft-modpack-server
```
> The following is the same command but broken down for readability  
```bash
docker run -it \
  --name my-minecraft-server
  -e JAVA_VERSION=17 \
  -e MC_VERSION=1.20.1 \
  -e MOD_LOADER=forge \
  -e MOD_LOADER_VERSION=47.4.0 \
  -e JAVA_XMX=2G \
  -e JAVA_XMS=2G \
  -v /path/to/server_data:/home/minecraft/server \
  -p 25565:25565 \
  minecraft-modpack-server
```
> **NOTE**: The format `25565:25565` is interpreted to `[port-on-host]:[port-on-container]` whereby `port-on-container` should remain fixed to `25565` since it is the default port for minecraft servers (only change this if you know how to adjust the server to use other ports in the server.properties). `port-on-host` on the other hand can and should be modified when using multiple containers to host multiple servers on the same machine at the same time. Examples for correct port configuration: `-p 25576:25565`, `-p 25532:25565`

You can find more example run commands in [here](docs/install_scripts.md)

### Accessing the Server Console

Once the container is running, the installation process begins. This process might take a while depending on your machine but once it's completed the Minecraft server starts automatically. You don't need to manually start the server—it will be ready to use as soon as the container is set up.  

To connect to the server from the same machine running the docker container. All you have to do is to add the server in the servers list. In the server address simply type in `localhost` and join as normal.  
Incase you used a different port pair, user the following format: `localhost:[port-on-host]`.


> **NOTICE!**: Don't close the terminal running the server before you "detach" from the server by hitting **CTR+A followed by CTR+D** for more information see [screen's documentation](https://help.ubuntu.com/community/Screen)

In case you closed the docker terminal running the container, you can still access the server console but you need to do some cleaning up:

Run the following command. Don't forget to replace `<container_name>` with your container' name (the value provided to `--name`) or it's ID. If you don't know the container's name, you can list all running containers with the command ```docker ps```:
```bash
docker exec -it <container_name> screen -r minecraft
```

if you get message similar to :

```
There is a screen on:
        *.minecraft     (01/01/20 15:00:00)     (Attached)
There is no screen to be resumed matching minecraft.
```

you first need to "detach" the "attached" screen by running:
```bash
docker exec -it <container_name> screen -d minecraft
```
and repeating the process

After attaching to the container, you can interact with the server console directly.

> **Tip for Non-Technical Users**: If you're unfamiliar with Docker commands, think of `docker exec` as a way to "open a door" into the container so you can see what's happening inside.

**Additional Notes**  

- **EULA**: To run the minecraft server you have to accept [Minecraft End(er)-User License Agreement (“EULA”)](https://account.mojang.com/documents/minecraft_eula) by setting the environment variable `-e EULA=true`. The container then creates an `eula.txt` file with `eula=true` in the server root folder.
- **Data Persistence**: Mount a volume to `/server` to persist server data across container restarts.
- **Logs**: Server logs are stored in the `/server` directory.  

**Troubleshooting**
- **Unsupported Java Version**: Ensure you set `JAVA_VERSION` to either `17` or `21`.
- **Unsupported Mod Loader**: Ensure you set `MOD_LOADER` to one of the supported options (`vanilla`, `forge`, `fabric`, `neoforge`).
- **Missing Environment Variables**: Make sure all required variables (`JAVA_VERSION`, `MC_VERSION`, `MOD_LOADER`, and `MOD_LOADER_VERSION` if applicable) are set.  
- **Monitoring the installation process**: You can access the last 1000 lines in the logs of the container by running `docker logs --tail 1000 -f <container-id>`

**License**
This Docker image is provided under the **MIT License**. Minecraft is a trademark of Mojang AB, and this image is not affiliated with or endorsed by Mojang AB.
