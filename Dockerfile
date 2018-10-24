FROM node:alpine
LABEL maintainer 'Martijn Pepping <martijn.pepping@automiq.nl>'

RUN addgroup cyberchef -S && \
    adduser cyberchef -G cyberchef -S && \
    apk update && \
    apk add nodejs curl && \
    rm -rf /var/cache/apk/* && \
    npm install -g grunt-cli && \
    npm install -g http-server

RUN cd /srv && \
    curl -L https://github.com/gchq/CyberChef/archive/v8.8.5.tar.gz | tar zxv && \
    cd  CyberChef-8.8.5 && \
    rm -rf .git && \
    npm install && \
    chown -R cyberchef:cyberchef /srv/CyberChef-8.8.5

USER cyberchef
    
RUN cd /srv/CyberChef-8.8.5 && \
    npm run postinstall && \
    grunt prod

WORKDIR /srv/CyberChef-8.8.5/build/prod
ENTRYPOINT ["http-server", "-p", "8000"]
