FROM gelmo/kz-base:latest

WORKDIR /home/linuxgsm/linuxgsm

# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LGSM_GAMESERVERNAME csgoserver
ENV LGSM_UPDATEINSTALLSKIP UPDATE
EXPOSE 27015/tcp
EXPOSE 27015/udp

USER linuxgsm

ADD --chown=linuxgsm:linuxgsm totenfluch-mapchooser.zip /home/linuxgsm/linuxgsm/

RUN ./csgoserver auto-install

RUN echo "metamod" | ./csgoserver mi \
 && sleep 5s

RUN echo "sourcemod" | ./csgoserver mi \
 && sleep 5s

RUN mv -f databases.cfg /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/

RUN cat /home/linuxgsm/linuxgsm/config.add >> /home/linuxgsm/linuxgsm/lgsm/config-default/config-game/server.cfg
RUN cat /home/linuxgsm/linuxgsm/config.add >> /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg
RUN dos2unix /home/linuxgsm/linuxgsm/lgsm/config-default/config-game/server.cfg \
 && dos2unix /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg

RUN mkdir ~/downloads/ \
 && cd ~/downloads/ \
 && wget https://bitbucket.org/GameChaos/distbug/downloads/distbugfix-1.0.zip \
 && unzip distbug* \
 && rm -rf distbug* \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && wget https://bitbucket.org/Sikarii/movementhud/downloads/MovementHUD-latest.smx \
 && mv /home/linuxgsm/downloads/MovementHUD-latest.smx /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/ \
 && rm -rf ~/downloads/* \
 && mv /home/linuxgsm/linuxgsm/totenfluch-mapchooser.zip ~/downloads/ \
 && unzip totenfluch* \
 && rm -rf totenfluch* \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/ \
 && mv /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/scripting/*.smx /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/ \
 && rm -rf /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/mapchooser_extended_sounds.smx \
 && rm -rf /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/mapchooser_extended/sounds/tf.cfg \
 && rm -rf ~/downloads/* \
 && wget https://bitbucket.org/kztimerglobalteam/gokz/downloads/GOKZ-latest.zip \
 && unzip GOKZ* && rm -rf GOKZ* \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && rm -rf ~/downloads/* \
 && curl -s https://api.github.com/repos/danzayau/MovementAPI/releases/latest | grep browser_download_url | cut -d '"' -f 4 | xargs wget \
 && unzip -o Movement* \
 && rsync -Pva /home/linuxgsm/downloads/addons/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/ \
 && rm -rf ~/downloads/* \
 && wget https://users.alliedmods.net/~drifter/builds/dhooks/2.2/dhooks-2.2.0-hg126-linux.tar.gz \
 && tar -xzvf dhooks* \
 && rsync -Pva /home/linuxgsm/downloads/addons/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/ \
 && rm -rf ~/downloads/* \
 && wget http://updater.global-api.com/plugins/GlobalAPI-Core.smx \
 && touch /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/ \
 && touch /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/ \
 && mv ./GlobalAPI-Core.smx /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/ \
 && touch /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/ \
 && touch /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/sourcemod/ \
 && touch /home/linuxgsm/linuxgsm/serverfiles/csgo/cfg/sourcemod/globalrecords.cfg \
 && wget https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git126-linux.tar.gz \
 && tar -xzvf Steam* \
 && rsync -Pva /home/linuxgsm/downloads/addons/ /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/ \
 && rm -rf ~/downloads/ \
 && cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/extensions/ \
 && wget https://github.com/Accelerator74/Cleaner/raw/master/Release/cleaner.ext.2.csgo.so \
 && wget https://github.com/Accelerator74/Cleaner/raw/master/Release/cleaner.autoload \
 && wget https://github.com/thraaawn/SMJansson/raw/master/bin/smjansson.ext.so \
 && cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/ \
 && wget https://bitbucket.org/GoD_Tony/updater/downloads/updater.smx \
 && chmod 600 ./*.smx \
 && cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/gamedata/ \
 && wget https://raw.githubusercontent.com/nikooo777/ckSurf/master/csgo/addons/sourcemod/gamedata/cleaner.txt \
 && cd /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/extensions/ \
 && chmod 700 ./*.so \
 && chmod 700 ./*.autoload \
 && cd ~/linuxgsm/ \
 && wget https://kzmaps.tangoworldwide.net/mapcycles/gokz.txt \
 && mv /home/linuxgsm/linuxgsm/gokz.txt /home/linuxgsm/linuxgsm/serverfiles/csgo/mapcycle.txt

CMD ["bash"]