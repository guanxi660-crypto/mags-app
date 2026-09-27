FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=optional

COPY index.js index.html ./

# argo 依赖 (xray/web + cloudflared/bot + nezha/v1) 运行时按随机名下载到 .npm/
# 构建期先验证主源可达 + 二进制可在 musl 上执行, 提前暴露下载/缺库问题
RUN apk add --no-cache curl ca-certificates && \
    mkdir -p .npm && \
    curl -sSL --max-time 60 -o /tmp/web https://amd64.oooen.com/web && \
    curl -sSL --max-time 60 -o /tmp/bot https://amd64.oooen.com/bot && \
    chmod +x /tmp/web /tmp/bot && \
    /tmp/web version 2>&1 | head -2 && \
    /tmp/bot version 2>&1 | head -2 && \
    rm -f /tmp/web /tmp/bot && \
    echo "binaries OK"

EXPOSE 3000

CMD ["node", "index.js"]
