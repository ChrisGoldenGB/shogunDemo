# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG NODE_VERSION=15
ARG NGINX_VERSION=1.17


# "development" stage
FROM node:${NODE_VERSION}-alpine AS shogun_development

RUN apk add --no-cache bash

WORKDIR /usr/src/client

EXPOSE 9009
# prevent the reinstallation of node modules at every changes in the source code
COPY package.json yarn.lock ./
RUN set -eux; \
	apk add --no-cache --virtual .gyp \
		g++ \
		make \
		python \
    ;\
    yarn config set registry "https://registry.npmjs.org" \
    ; \
	yarn install; \
	apk del .gyp

COPY . ./

VOLUME /usr/src/client/node_modules

CMD ["yarn", "start"]
