
FROM node:18.8.0-alpine
COPY package*.json ./
RUN npm install && npm cache clean --force
COPY * ./
RUN npm run build
USER node
EXPOSE 4000
CMD ["node", "dist/main.js"]