FROM gelmo/kz-srcds-plug:latest

WORKDIR /home/linuxgsm/linuxgsm

# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LGSM_GAMESERVERNAME csgoserver
ENV LGSM_UPDATEINSTALLSKIP UPDATE
EXPOSE 27015/tcp
EXPOSE 27015/udp

USER linuxgsm

RUN cd \
 && mkdir downloads \
 && cd downloads/ \
 && wget https://bitbucket.org/kztimerglobalteam/kztimerglobal/downloads/1.90_Full.zip \
 && unzip 1.90_Full.zip && rm -rf 1.90_Full.zip \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/ \
 && wget https://kzmaps.tangoworldwide.net/mapcycles/kztimer.txt \
 && mv /home/linuxgsm/downloads/kztimer.txt /home/linuxgsm/linuxgsm/serverfiles/csgo/mapcycle.txt \
 && rm -rf ~/downloads/* \
 && cd ~/downloads/ \
 && wget https://kzmaps.tangoworldwide.net/Global-Maps-27-02-2019_KZTIMER.zip \
 && unzip Global* \
 && rm -rf Global* \
 && rsync -Pva /home/linuxgsm/downloads/ /home/linuxgsm/linuxgsm/serverfiles/csgo/maps/ \
 && rm -rf ~/downloads/* \
 && cat /home/linuxgsm/linuxgsm/exception.add >> /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/kztimer/exception_list.txt \
 && dos2unix /home/linuxgsm/linuxgsm/serverfiles/csgo/addons/sourcemod/configs/kztimer/exception_list.txt \
 && cd ~/linuxgsm/

CMD ["bash"]