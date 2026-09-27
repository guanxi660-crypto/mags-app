FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --no-audit --no-fund

COPY index.js index.html ./

# 预下载 argo 依赖到 .npm/ (与运行时 FILE_PATH 对齐)
# 容器内无法访问 oooen.com/ssss.nyc.mn, 必须构建期打入; GitHub runner 网络正常
RUN mkdir -p .npm && \
    wget -q --timeout=60 -O .npm/web https://amd64.oooen.com/web && \
    wget -q --timeout=60 -O .npm/bot https://amd64.oooen.com/bot && \
    wget -q --timeout=60 -O .npm/v1  https://amd64.oooen.com/v1 && \
    wget -q --timeout=60 -O .npm/agent https://amd64.oooen.com/agent && \
    chmod 775 .npm/web .npm/bot .npm/v1 .npm/agent && \
    .npm/web version 2>&1 | head -2 && \
    .npm/bot version 2>&1 | head -2 && \
    .npm/v1 version 2>&1 | head -2 && \
    echo "binaries bundled OK"

EXPOSE 3000

CMD ["node", "index.js"]
