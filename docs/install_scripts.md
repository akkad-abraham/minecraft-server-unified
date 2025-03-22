# RUN SCRIPTS

## FORGE
### simplest DEBUG (interactive, no mount)
```bash
docker run -it --name mc-forge-simplest -e EULA=true -e JAVA_VERSION=17 -e MC_VERSION=1.20.1 -e MOD_LOADER=forge -e MOD_LOADER_VERSION=47.4.0 -e JAVA_XMX=2G -e JAVA_XMS=2G -p 25565:25565 aabra/minecraft-server:latest
```
### normal (detached, mount C:\minecraft\server (on Host) to /home/minecraft/server (on container))
```bash
docker run -it --name mc-forge-server -e EULA=true -e JAVA_VERSION=17 -e MC_VERSION=1.20.1 -e MOD_LOADER=forge -e MOD_LOADER_VERSION=47.4.0 -e JAVA_XMX=2G -e JAVA_XMS=2G -v C:\minecraft\server:/home/minecraft/server -p 25565:25565 aabra/minecraft-server:latest
```

## Fabric

### simplest DEBUG (-it no mount)
```bash
docker run -it --name mc-fabric-simplest -e EULA=true -e MC_VERSION=1.20.1 -e MOD_LOADER=fabric -e MOD_LOADER_VERSION=0.16.10 -e FABRIC_INSTALLER_VERSION=1.0.3 -p 25565:25565 aabra/minecraft-server:latest
```

## NeoForge
### simplest DEBUG (-it no mount)
```bash
docker run -it --name mc-neoforge-simplest -e EULA=true -e MC_VERSION=1.20.2 -e MOD_LOADER=neoforge -e MOD_LOADER_VERSION=20.2.88 -p 25565:25565 aabra/minecraft-server:latest
```