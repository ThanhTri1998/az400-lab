# L15 container scanning demo image for the shared sample app.
# BASE_IMAGE is a build-arg so the workflow can scan an old (vulnerable) base vs a current one.
ARG BASE_IMAGE=node:22-alpine

# Stage 1: install production deps (needs npm)
FROM ${BASE_IMAGE} AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Stage 2: runtime. Remove npm/npx/corepack/yarn: not needed to RUN the app, and the bundled
# npm CLI is where Trivy found most HIGH CVEs (tar, brace-expansion, ip-address...). Smaller attack surface.
FROM ${BASE_IMAGE}
RUN rm -rf /usr/local/lib/node_modules /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack /opt/yarn* /usr/local/bin/yarn*
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./
COPY src ./src
USER node
EXPOSE 3100
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3100/health || exit 1
CMD ["node", "src/server.js"]
