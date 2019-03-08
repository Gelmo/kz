FROM gelmo/kz-srcds:latest

WORKDIR /home/linuxgsm/linuxgsm

# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LGSM_GAMESERVERNAME csgoserver
ENV LGSM_UPDATEINSTALLSKIP UPDATE

USER linuxgsm

ADD --chown=linuxgsm:linuxgsm totenfluch-mapchooser.zip /home/linuxgsm/linuxgsm/
ADD --chown=linuxgsm:linuxgsm exception.add /home/linuxgsm/linuxgsm/

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
 && rm -rf ~/downloads/ \
 && rm -rf /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/plugins/mapchooser_extended_sounds.smx \
 && rm -rf /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/mapchooser_extended/sounds/tf.cfg \
 && cd ~/linuxgsm/

CMD ["bash"]