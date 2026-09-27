FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --no-audit --no-fund

COPY index.js index.html ./

EXPOSE 3000

CMD ["node", "index.js"]
