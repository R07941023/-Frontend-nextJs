# 使用官方 Node.js 圖像作為基礎
FROM node:20-alpine AS builder

# 設定工作目錄
WORKDIR /app

# 複製 package.json 和 package-lock.json
COPY package*.json ./

# 安裝依賴
RUN npm install --frozen-lockfile

# 複製專案代碼
COPY . .

# 編譯 Next.js 應用
RUN npm run build

# 使用更小的 Node.js 圖像來運行應用
FROM node:20-alpine AS runner

# 設定工作目錄
WORKDIR /app

# 複製編譯好的應用
COPY --from=builder /app ./

# 設定環境變數
ENV NODE_ENV=production

# 開放 3000 端口
EXPOSE 3000

# 啟動應用
CMD ["npm", "run", "start"]