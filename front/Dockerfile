FROM node:18-alpine

RUN apk update \
    && apk add --no-cache \
    npm

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . .

RUN npm install

CMD ["npm start"]
