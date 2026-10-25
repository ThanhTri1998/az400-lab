# L15 container scanning demo image for the shared sample app.
# BASE IMAGE is a build-arg so the workflow can scan an old (vulnerable) base vs a current one.
ARG BASE_IMAGE=node:22-alpine
FROM ${BASE_IMAGE}
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY src ./src
USER node
EXPOSE 3100
CMD ["node", "src/server.js"]
