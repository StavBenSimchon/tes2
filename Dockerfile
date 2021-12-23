FROM node:alpine as base

WORKDIR /app
RUN apk add --no-cache jq
# ARG NPM_AUTH_TOKEN
# ENV NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}
COPY package.json package.json
COPY package-lock.json package-lock.json
COPY .npmrc .

ARG NPM_AUTH_TOKEN='d046c1aa-5505-4089-afa2-63ae427f0ee0'
ENV NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}

FROM base as test
RUN npm ci
COPY . .
RUN npm run test

FROM base as prod
RUN npm ci --production
COPY . .
RUN touch dist.js
CMD [ "node", "server.js" ]