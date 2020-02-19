# kz
Run a KZ server in a Docker container!

The base of this image is [a SteamCMD image maintained by Tim Cheung](https://hub.docker.com/r/timche/csgo). I am rebasing my project on his image and entrypoint script, as his implementation is significantly better for production usage. I will do my best to keep this up to date with his changes.

## How to Use This Image

```
$ docker run \
  -v=csgo:/home/csgo/server \
  --net=host \
  gelmo/kz
```

- The server will be installed on a volume named `csgo` to [ensure persistence of server files](https://docs.docker.com/storage/).
- The server will be running on the default port `27015` on the `host` network for [optimal network performance](https://docs.docker.com/network/host/)
- The server will be running in LAN mode since a Game Server Login Token (GSLT) is required to run the server on the internet.
- The server will be running [GOKZ](https://bitbucket.org/kztimerglobalteam/gokz/src/master/)

### Game Server Login Token (GSLT)

- [Get GSLT](https://steamcommunity.com/dev/managegameservers)
- [What is GSLT?](https://docs.linuxgsm.com/steamcmd/gslt#what-is-gslt)
- [FAQ](https://docs.linuxgsm.com/steamcmd/gslt#faq)

### Environment Variables

##### `CSGO_GSLT`

Your [Game Server Login Token](https://steamcommunity.com/dev/managegameservers) if you want to run the server on the internet.

##### `CSGO_WS_API_KEY`

Your [Steam Web API Key](https://steamcommunity.com/dev/apikey) to download workshop maps.

##### `TIMER`

GOKZ will always be installed, unless [`TIMER`](#timer) is set to `kztimer`

##### `CSGO_IP`

Default: `0.0.0.0`

The IP the server is assigned to. In most cases the default value is sufficient, but if you want to run a [GOTV](https://developer.valvesoftware.com/wiki/SourceTV) server or have issues connecting to the server, the actual IP of the server should be set.

##### `CSGO_PORT`

Default: `27015`

The port the server is listening to.

##### `CSGO_MAX_PLAYERS`

Default: `16`

The maximum players allowed to join the server.

##### `CSGO_HOSTNAME`

The server name.

##### `CSGO_RCON_PW`

Default: none

The RCON password to administrate the server.

##### `CSGO_PW`

Default: none

The password to join the server.

##### `CSGO_TICKRATE`

Default: `128`

The server game tick interval.

##### `CSGO_CUSTOM_CONFIGS_DIR`

Default: `/var/csgo`

Absolute path to a directory in the container containing custom config files and maps. Changing this is not recommended in order to follow the documentation.

##### `CSGO_DEBUG`

Print commands in the log.

##### `CSGO_PARAMS`

Additional [parameters](https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-line_parameters) to pass to `srcds_run`.

### Populate with Own Configs and Maps

The server can be populated with your own config files and maps by copying the files from the custom configs directory located at [`CSGO_CUSTOM_CONFIGS_DIR`](#csgo_custom_configs_dir) to the `csgo` folder at each start of the container. [`CSGO_CUSTOM_CONFIGS_DIR`](#csgo_custom_configs_dir) is a mounted directory from the host system. The custom configs and maps directory must have the same folder structure as the `csgo` folder in order to add or overwrite the files at the paths.

#### Example

##### Host

Add configs to `/home/user/csgo`:

```
.
├── addons
│   └── sourcemod
│       └── configs
│           └── admins_simple.ini # Will be overwritten
└── cfg
    └── server.cfg # Will be added
```

##### Container

Mount `/home/user/custom-configs` to [`CSGO_CUSTOM_CONFIGS_DIR`](#csgo_custom_configs_dir) in the container:

```
$ docker run \
  -v=csgo:/home/csgo/server \
  -v=/home/user/csgo:/var/csgo \ # Mount the custom configs directory
  --net=host \
  gelmo/kz
```

### Updating the Server

Once the server has been installed, the container will check for an update at every start.

#### Manually

Restart the container with [`docker restart`](https://docs.docker.com/engine/reference/commandline/restart/).

##### Example

Container named `csgo`:

```
$ docker restart csgo
```

### Public Server Example

```
$ docker run \
  -v=csgo:/home/csgo/server \
  -v=/home/user/csgo:/var/csgo \
  --net=host \
  --env CSGO_GSLT=ABC123 \
  --env CSGO_WS_API_KEY=123ABC \
  --env CSGO_HOSTNAME="ServerName" \
  --env CSGO_PW=ServerPass \
  --name=csgo \
  gelmo/kz
```

This readme will be updated in the future. Todo list:

- Add documentation for using a separate sql instance instead of sqlite
- Add documentation for running multiple instances in a stack via compose w/ discreet sql container and shared csgo volume
