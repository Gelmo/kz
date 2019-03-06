FROM gelmo/kz-base:latest

WORKDIR /home/linuxgsm/linuxgsm

# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LGSM_GAMESERVERNAME csgoserver
ENV LGSM_UPDATEINSTALLSKIP UPDATE

USER linuxgsm

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

CMD ["bash"]