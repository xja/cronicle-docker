FROM    node:18-bullseye
ENV     CRONICLE_VERSION=0.9.24
WORKDIR /opt/cronicle
RUN     mkdir -p /opt/cronicle \
            && cd /opt/cronicle \
            && curl -L https://github.com/jhuckaby/Cronicle/archive/v${CRONICLE_VERSION}.tar.gz | tar zxvf - --strip-components 1 \
            && npm install \
            && node bin/build.js dist \
            && rm -Rf /root/.npm
RUN     curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash
RUN     echo 'source "$HOME/.rye/env"' >> ~/.bashrc
COPY    docker-entrypoint.js ./bin/
ENV     CRONICLE_foreground=1
ENV     CRONICLE_echo=1
ENV     CRONICLE_color=1
ENV     debug_level=1
RUN     node bin/build.js dist && bin/control.sh setup
CMD     ["node", "bin/docker-entrypoint.js"]