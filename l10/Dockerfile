# L10: container image of the shared sample app, pushed to GitHub Container Registry (ghcr.io)
FROM node:22-alpine
LABEL org.opencontainers.image.source="https://github.com/ThanhTri1998/az400-lab"
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY src ./src
ENV PORT=3100
USER node
EXPOSE 3100
CMD ["node", "src/server.js"]
