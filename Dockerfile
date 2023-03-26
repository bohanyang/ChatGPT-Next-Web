FROM node:18-alpine AS builder

RUN set -eux; \
    apk add --no-cache \
        ca-certificates \
        curl \
        tar \
        xz \
        git

COPY package.json /app/

RUN --mount=type=cache,target=/root/.local/share/pnpm/store/v3 \
    set -eux; \
    corepack enable; \
    corepack prepare pnpm@latest --activate; \
    cd /app; \
    pnpm install

RUN --mount=type=bind,source=.,target=/usr/src/app \
    set -eux; \
    cp -R /usr/src/app/. /app; \
    cd /app; \
    pnpm build

FROM node:18-alpine

COPY --from=builder --chown=www-data:www-data /app/.next/standalone /app/
COPY --from=builder --chown=www-data:www-data /app/.next/static /app/.next/static/
COPY --from=builder --chown=www-data:www-data /app/public /app/public/

WORKDIR /app

ENTRYPOINT ["node", "server.js"]
