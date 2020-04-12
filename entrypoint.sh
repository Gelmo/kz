#!/bin/bash

set -e

set -x

shopt -s extglob

gokz="https://bitbucket.org/kztimerglobalteam/gokz/downloads/GOKZ-latest.zip"
kztver=($(wget -qO- http://updater.kztimerglobal.com/KZTimerGlobal.txt | grep Latest | awk -F "\"" '{print $4}'))
kztimer="https://bitbucket.org/kztimerglobalteam/kztimerglobal/downloads/${kztver}_Full.zip"
mhudtrackgokz="https://bitbucket.org/Sikarii/movementhud-tracking/downloads/MovementHUD-Tracking-GOKZ-latest.smx"
mhudtrackkzt="https://bitbucket.org/Sikarii/movementhud-tracking/downloads/MovementHUD-Tracking-KZTimer-latest.smx"

mapcycle='https://kzmaps.tangoworldwide.net/mapcycles/gokz.txt'
kztmapcycle='https://kzmaps.tangoworldwide.net/mapcycles/kztimer.txt'

STEAM_DIR=/home/csgo/Steam
SERVER_DIR=/home/csgo/server
SERVER_INSTALLED_LOCK_FILE=/home/csgo/server/installed.lock
CSGO_DIR=/home/csgo/server/csgo
CSGO_CUSTOM_CONFIGS_DIR="${CSGO_CUSTOM_CONFIGS_DIR-/var/csgo}"

syncPlugins() {
    echo "> Syncing plugins ..."
    rsync -rti /home/csgo/plugins/ /home/csgo/server/csgo/
    echo '> Done'
}

installGOKZ() {
    echo "> Installing GOKZ ..."
    cd $CSGO_DIR/addons/sourcemod/plugins
    if [ -f ./KZTimerGlobal.smx ]; then
      mv ./KZ*.smx disabled
    fi
    if [ -f ./MovementHUD-Tracking-KZTimer-latest.smx ]; then
      mv ./MovementHUD-Tracking*.smx disabled
    fi
    if [ -f ./MovementHUD-Tracking-GOKZ-latest.smx ]; then
      mv ./MovementHUD-Tracking*.smx disabled
    fi
    wget -q $mhudtrackgokz
    mv ./fun*.smx disabled
    mv ./playercommands.smx disabled
    cd $CSGO_DIR
    wget -q -O plugin.zip $gokz
    unzip -qo plugin.zip
    rm plugin.zip
    wget -q -O mapcycle.txt $mapcycle
    cp -p mapcycle.txt $CSGO_DIR/cfg/sourcemod/gokz/gokz-localranks-mappool.cfg
    echo '> Done'
}

installKZTimer() {
    echo "> Installing KZTimer ..."
    cd $CSGO_DIR/addons/sourcemod/plugins
    if [ -f ./gokz-core.smx ]; then
      mv ./gokz*.smx disabled
    fi
    if [ -f ./MovementHUD-Tracking-KZTimer-latest.smx ]; then
      mv ./MovementHUD-Tracking*.smx disabled
    fi
    if [ -f ./MovementHUD-Tracking-GOKZ-latest.smx ]; then
      mv ./MovementHUD-Tracking*.smx disabled
    fi
    wget -q $mhudtrackkzt
    mv ./fun*.smx disabled
    mv ./playercommands.smx disabled
    cd $CSGO_DIR
    wget -q -O plugin.zip $kztimer
    unzip -qo plugin.zip
    rm plugin.zip
    wget -q -O mapcycle.txt $kztmapcycle
    echo '> Done'
}

#downloadMaps() {
#    echo "> Downloading maps ..."
#    cd /home/csgo/server/csgo/maps/workshop
#    /bin/bash /home/csgo/mapsync.sh
#    cd /home/csgo/server/csgo
#}

#downloadMapsKZT() {
#    echo "> Downloading maps ..."
#    cd /home/csgo/server/csgo/maps/workshop
#    /bin/bash /home/csgo/mapsynckzt.sh
#    cd /home/csgo/server/csgo
#}

installServer() {
  echo '> Installing server ...'

  $STEAM_DIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update 740 validate \
    +quit

  echo '> Done'

  touch $SERVER_INSTALLED_LOCK_FILE

}

applyCustomConfigs() {
  echo "> Checking for custom configs at \"$CSGO_CUSTOM_CONFIGS_DIR\" ..."

  if [ -d "$CSGO_CUSTOM_CONFIGS_DIR" ]; then
      echo '> Found custom configs, applying ...'
      rsync -rti $CSGO_CUSTOM_CONFIGS_DIR/ $CSGO_DIR
      echo '> Done'
  else
      echo '> No custom configs found to apply'
  fi
}

startServer() {
  echo '> Starting server ...'

  optionalParameters=""

  if [ -n "$CSGO_GSLT" ]; then
    optionalParameters+=" +sv_setsteamaccount $CSGO_GSLT"
  else
    echo '> Warning: Environment variable "CSGO_GSLT" is not set, but is required to run the server on the internet. Running the server in LAN mode.'
    optionalParameters+=" +sv_lan 1"
  fi

  if [ -n "$CSGO_RCON_PW" ]; then
    optionalParameters+=" +rcon_password $CSGO_RCON_PW"
  fi

  if [ -n "$CSGO_PW" ]; then
    optionalParameters+=" +sv_password $CSGO_PW"
  fi

  if [ -n "$CSGO_HOSTNAME" ]; then
    optionalParameters+=" +hostname "'"'"$CSGO_HOSTNAME"'"'
  fi

  if [ -n "$CSGO_WS_API_KEY" ]; then
    optionalParameters+=" -authkey $CSGO_WS_API_KEY +host_workshop_map 1326959512"
  else
    echo '> Warning: Environment variable "CSGO_WS_API_KEY" is not set, so you need to mount maps and set environment variable "CSGO_CUSTOM_CONFIGS_DIR"'
  fi

  if [ -n "$KZ_API_KEY" ]; then
    echo $KZ_API_KEY > $CSGO_DIR/cfg/sourcemod/globalrecords.cfg
  else
    echo '> Warning: Environment variable "KZ_API_KEY" is not set, so you need to mount globalrecords.cfg and set environment variable "CSGO_CUSTOM_CONFIGS_DIR" if you intend to make this server "global"'
  fi

  #if [ "$DLMAPS" == "yes" ]; then
  #  optionalParameters+=" -nowatchdog"
  #fi

  $SERVER_DIR/srcds_run \
      -game csgo \
      -console \
      -norestart \
      -usercon \
      -nobreakpad \
      +ip "${CSGO_IP-0.0.0.0}" \
      -port "${CSGO_PORT-27015}" \
      -tickrate "${CSGO_TICKRATE-128}" \
      -maxplayers_override "${CSGO_MAX_PLAYERS-16}" \
      +game_type 3 \
      +game_mode 0 \
      +map de_mirage \
      $optionalParameters \
      $CSGO_PARAMS
}

updateServer() {
  echo '> Checking for server update ...'

  $STEAM_DIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir $HOME/server \
    +app_update 740 \
    +quit

  echo '> Done'
}

if [ -f "$SERVER_INSTALLED_LOCK_FILE" ]; then
  updateServer
else
  installServer
fi

syncPlugins

if [ "$TIMER" == "kztimer" ]; then
  installKZTimer
else
  installGOKZ
fi

#if [ "$DLMAPS" == "yes" ]; then
#  if [ "$TIMER" == "kztimer" ]; then
#    downloadMapsKZT
#  else
#    downloadMaps
#  fi
#fi

if [ "$MAPCHOOSER" == "yes" ]; then
  mv $CSGO_DIR/addons/sourcemod/plugins/disabled/mapchooser.smx $CSGO_DIR/addons/sourcemod/plugins/
  mv $CSGO_DIR/addons/sourcemod/plugins/disabled/nominations.smx $CSGO_DIR/addons/sourcemod/plugins/
  mv $CSGO_DIR/addons/sourcemod/plugins/disabled/rockthevote.smx $CSGO_DIR/addons/sourcemod/plugins/
fi

applyCustomConfigs

startServer
