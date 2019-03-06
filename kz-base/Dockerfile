FROM joshhsoj1902/linuxgsm-docker:latest

WORKDIR /home/linuxgsm/linuxgsm

# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LGSM_GAMESERVERNAME csgoserver
ENV LGSM_UPDATEINSTALLSKIP UPDATE

USER root 

# Install dependencies and clean
RUN apt-get update && \
    apt-get install -y \
        sqlite \
        rsync \
        zlib1g:i386 \
        libc6-i386 \
        lib32stdc++6 \
		nano \
		vim \
        locales \
        dos2unix \
    # Cleanup
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY --from=joshhsoj1902/parse-env:1.0.3 /go/src/github.com/joshhsoj1902/parse-env/main /usr/bin/parse-env
COPY --from=hairyhenderson/gomplate:v3.1.0-alpine /bin/gomplate /usr/bin/gomplate

RUN find /home/linuxgsm/linuxgsm -type f -name "*.sh" -exec chmod u+x {} \; \
 && find /home/linuxgsm/linuxgsm -type f -name "*.py" -exec chmod u+x {} \; \
 && chmod u+x /home/linuxgsm/linuxgsm/lgsm/functions/README.md

ADD --chown=linuxgsm:linuxgsm common.cfg.tmpl ./lgsm/config-default/config-lgsm/
ADD --chown=linuxgsm:linuxgsm functions/* /home/linuxgsm/linuxgsm/lgsm/functions/
ADD --chown=linuxgsm:linuxgsm databases.cfg /home/linuxgsm/linuxgsm/
ADD --chown=linuxgsm:linuxgsm csgoserver.cfg /home/linuxgsm/linuxgsm/lgsm/config-lgsm/csgoserver/
ADD --chown=linuxgsm:linuxgsm config.add /home/linuxgsm/linuxgsm/

RUN locale-gen --purge en_US.UTF-8 \
 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

USER linuxgsm

RUN parse-env --env "LGSM_" >> env.json
RUN rm -f INSTALLING.LOCK
RUN mkdir -p ~/linuxgsm/lgsm/config-lgsm/csgoserver

RUN mkdir /home/linuxgsm/linuxgsm/log/ \
 && mkdir /home/linuxgsm/linuxgsm/log/script/ \
 && touch /home/linuxgsm/linuxgsm/log/script/csgoserver-script.log \
 && chmod +x /home/linuxgsm/linuxgsm/lgsm/functions/*.sh \
 && ./linuxgsm.sh csgoserver

CMD ["bash"]