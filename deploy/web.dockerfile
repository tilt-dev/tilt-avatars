FROM node:16-bullseye-slim

ENV YARN_CACHE_FOLDER=/cache/yarn

WORKDIR /app

# install dependencies
COPY web/package.json web/yarn.lock ./
RUN --mount=type=cache,target=/cache/yarn \
  yarn install

# copy app source
COPY web/ ./

CMD ["yarn", "dev"]
