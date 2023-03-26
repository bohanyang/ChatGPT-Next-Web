FROM node:18-alpine AS builder

RUN set -eux; \
    apk add --no-cache \
        ca-certificates \
        curl \
        tar \
        xz \
        git

COPY package.json yarn.lock /app/

RUN --mount=type=cache,target=/root/.cache/yarn \
    set -eux; \
    corepack enable; \
    corepack prepare yarn@1.22.19 --activate; \
    cd /app; \
    yarn install

RUN --mount=type=bind,source=.,target=/usr/src/app \
    set -eux; \
    cp -R /usr/src/app/. /app; \
    cd /app; \
    yarn build

FROM node:18-alpine

COPY --from=builder /app/.next/standalone /app/
COPY --from=builder /app/.next/static /app/.next/static/
COPY --from=builder /app/public /app/public/

WORKDIR /app

ENTRYPOINT ["node", "server.js"]
