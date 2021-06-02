FROM mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.13
RUN apk update

ENV NODE_VERSION=14.16.1

### INSTALL NODE
RUN apk add --no-cache nodejs

ENV YARN_VERSION=1.10.1

RUN apk add --no-cache --virtual .build-deps-yarn \
        gnupg \
        tar \
        && for key in \
            6A010C5166006599AA17F08146C2130DFD2497F5 \
        ; do \
            gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" \
            || gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" \
            || gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
        done \
            && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
            && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
            && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
            && mkdir -p /opt \
            && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
            && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
            && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
            && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
            && apk del .build-deps-yarn

# Add label for bring your own node in azure devops
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"

# Start node
CMD [ "node" ]
