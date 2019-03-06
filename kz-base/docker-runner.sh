#!/bin/bash

#Set ENV defaults

if [ -n "$LGSM_PORT" ]; then
  if [ -z "$LGSM_CLIENTPORT" ]; then
    clientport=$(($LGSM_PORT-10))
    echo "clientPort $clientport"
    export LGSM_CLIENTPORT=$clientport
  fi
  if [ -z "$LGSM_SOURCETVPORT" ]; then
    sourcetvport=$(($LGSM_PORT+5))
    echo "sourcetvport $sourcetvport"
    export LGSM_SOURCETVPORT=$sourcetvport
  fi
fi

parse-env --env "LGSM_" >> env.json

rm -f INSTALLING.LOCK

echo "IP is set to "${LGSM_IP}

mkdir -p ~/linuxgsm/lgsm/config-lgsm/csgoserver
gomplate -d env=~/linuxgsm/env.json -f ~/linuxgsm/lgsm/config-default/config-lgsm/common.cfg.tmpl -o ~/linuxgsm/lgsm/config-lgsm/csgoserver/common.cfg
if [ -f ~/linuxgsm/lgsm/config-lgsm/csgoserver/csgoserver.cfg.tmpl ]; then
  gomplate -d env=~/linuxgsm/env.json -f ~/linuxgsm/lgsm/config-lgsm/csgoserver/csgoserver.cfg.tmpl -o ~/linuxgsm/lgsm/config-lgsm/csgoserver/csgoserver.cfg
fi
echo "DONE GOMPLATING"

if [ -n "$LGSM_UPDATEINSTALLSKIP" ]; then
  case "$LGSM_UPDATEINSTALLSKIP" in
  "UPDATE")
      touch INSTALLING.LOCK
      ./linuxgsm.sh csgoserver
      ./csgoserver auto-install
      rm -f INSTALLING.LOCK
      
      echo "Game has been updated. Starting"
      ;;
  "INSTALL")
      touch INSTALLING.LOCK  
      ./linuxgsm.sh csgoserver
      ls -ltr
      ./csgoserver auto-install
      rm -f INSTALLING.LOCK
       
      echo "Game has been installed. Exiting"
      exit
      ;;
  esac
fi

if [ ! -f csgoserver ]; then
    echo "No game is installed, please set LGSM_UPDATEINSTALLSKIP"
    exit 1
fi

# # configure game-specfic settings
# gomplate -f ${servercfgfullpath}.tmpl -o ${servercfgfullpath}   // I can't predict what the filename is. 

#
./csgoserver start
sleep 30s
#

./csgoserver details
sleep 5s
./csgoserver monitor

tail -F ~/linuxgsm/log/console/csgoserver-console.log -F ~/linuxgsm/log/script/csgoserver-script.log -F ~/linuxgsm/log/script/csgoserver-alert.log
#
while :
do
./csgoserver monitor
sleep 30s
done
