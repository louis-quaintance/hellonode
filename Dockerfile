FROM node:4.4

ENV NODE_ENV=production
ENV npm_config_loglevel=warn
ENV NODE_PATH=/usr/src

RUN mkdir -p /usr/src
WORKDIR /usr/src

COPY package.json /usr/src/
COPY server.js /usr/src/

RUN npm install
RUN npm cache clean

EXPOSE 8080

CMD [ "node", "server.js" ]
