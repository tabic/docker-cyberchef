FROM alpine:3.5
LABEL maintainer 'Martijn Pepping <martijn.pepping@automiq.nl>'

RUN addgroup cyberchef -S && \
    adduser cyberchef -G cyberchef -S && \
    apk update && \
    apk add nodejs curl git && \
    rm -rf /var/cache/apk/* && \
    npm install -g grunt-cli && \
    npm install -g http-server

RUN cd /srv && \
    curl -L https://github.com/gchq/CyberChef/archive/v6.4.5.tar.gz | tar zxv && \
    cd  CyberChef-6.4.5 && \
    rm -rf .git && \
    npm install && \
    npm cache rm && \
    chown -R cyberchef:cyberchef /srv/CyberChef-6.4.5 && \
    grunt prod

WORKDIR /srv/CyberChef-6.4.5/build/prod
USER cyberchef
ENTRYPOINT ["http-server", "-p", "8000"]
