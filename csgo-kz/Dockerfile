FROM timche/csgo:latest

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wait-for-it \
    bsdtar \
    && rm -rf /var/lib/apt/lists/*

USER csgo

WORKDIR /home/csgo

RUN mkdir plugins

WORKDIR /home/csgo/plugins

RUN wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar zxf -
RUN wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6462-linux.tar.gz | tar zxf -
RUN wget -qO- https://users.alliedmods.net/~drifter/builds/dhooks/2.2/dhooks-2.2.0-hg132-linux.tar.gz | tar zxf -
RUN wget -qO- https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git131-linux.tar.gz | tar zxf -
RUN wget -qO- https://github.com/danzayau/MovementAPI/releases/download/2.1.0/MovementAPI-v2.1.0.zip | bsdtar xf -
RUN wget -qO- https://bitbucket.org/kztimerglobalteam/globalrecordssmplugin/downloads/GlobalAPI-Core-v.1.2.0.zip | bsdtar --strip 1 -xf -
RUN wget -qO- https://bitbucket.org/kztimerglobalteam/globalrecordssmplugin/downloads/GlobalAPI-Jumpstats-v.1.2.1.zip | bsdtar --strip 1 -xf -
RUN wget -qO- https://bitbucket.org/GameChaos/zone-stopwatch/downloads/ztopwatch-1.00.zip | bsdtar xf -
RUN wget -qO- https://gokz.tv/fastdl/gokz_particles/gokz_particles.rar | bsdtar xf -
RUN wget -qO- https://github.com/e54385991/console-cleaner/archive/master.zip | bsdtar --strip 1 -xf - && rm -rf README.md src

WORKDIR /home/csgo/plugins/addons/sourcemod

RUN wget -qO chooser.zip https://build.kxnrl.com/MapChooser-Redux/1.10/MapChooser-Redux-git188-c98291d.zip && bsdtar -xf chooser.zip && rm chooser.zip LICENSE README.md

WORKDIR /home/csgo/plugins/addons/sourcemod/plugins

RUN wget -q https://bitbucket.org/Sikarii/movementhud/downloads/MovementHUD-latest.smx
RUN wget -q https://github.com/DevRuto/GOKZ-Scoreboard-Timer/releases/download/0.05/scoreboardtimer.smx
RUN wget -q https://github.com/Franc1sco/FixHintColorMessages/raw/master/FixHintColorMessages.smx
RUN wget -q https://github.com/ismail0234/Benson-Map-Crash-Fixer/raw/master/mapcrashfixer.smx
RUN wget -q https://bitbucket.org/GoD_Tony/updater/downloads/updater.smx

WORKDIR /home/csgo/plugins/addons/sourcemod/extensions

RUN wget -q https://github.com/thraaawn/SMJansson/raw/master/bin/smjansson.ext.so

RUN chmod 600 /home/csgo/plugins/addons/sourcemod/plugins/*.smx
RUN chmod 700 /home/csgo/plugins/addons/sourcemod/extensions/*.so
RUN chmod 700 /home/csgo/plugins/addons/sourcemod/extensions/*.autoload

WORKDIR /home/csgo

COPY databases.cfg /home/csgo/plugins/addons/sourcemod/configs/

COPY entrypoint.sh /home/csgo/

USER root

RUN chmod +x /home/csgo/entrypoint.sh

USER csgo

CMD [ "/home/csgo/entrypoint.sh" ]