FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --no-audit --no-fund

COPY index.js index.html ./

# 预下载 argo 依赖到 .npm/ (与运行时 FILE_PATH 对齐)
# 容器内无法访问 oooen.com/ssss.nyc.mn, 必须构建期打入; GitHub runner 网络正常
RUN mkdir -p bundle && \
    wget -q --timeout=60 -O bundle/web https://amd64.oooen.com/web && \
    wget -q --timeout=60 -O bundle/bot https://amd64.oooen.com/bot && \
    wget -q --timeout=60 -O bundle/v1  https://amd64.oooen.com/v1 && \
    wget -q --timeout=60 -O bundle/agent https://amd64.oooen.com/agent && \
    chmod 775 bundle/web bundle/bot bundle/v1 bundle/agent && \
    bundle/web version 2>&1 | head -2 && \
    bundle/bot version 2>&1 | head -2 && \
    bundle/v1 version 2>&1 | head -2 && \
    echo "binaries bundled OK"

EXPOSE 3000

CMD ["node", "index.js"]
