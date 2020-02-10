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
ADD --chown=linuxgsm:linuxgsm exception.add /home/linuxgsm/linuxgsm/

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
 && wget https://bitbucket.org/kztimerglobalteam/kztimerglobal/downloads/1.90_Full.zip \
 && unzip 1.90_Full.zip && rm -rf 1.90_Full.zip \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && wget https://kzmaps.tangoworldwide.net/mapcycles/kztimer.txt \
 && mv /home/linuxgsm/downloads/kztimer.txt /home/linuxgsm/linuxgsm/serverfiles/csgo/mapcycle.txt \
 && rm -rf ~/downloads/ \
 && cat /home/linuxgsm/linuxgsm/exception.add >> /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/kztimer/exception_list.txt \
 && dos2unix /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/kztimer/exception_list.txt \
 && cd ~/linuxgsm/

CMD ["bash"]