# =========================
# STAGE 1: Build
# =========================
FROM node:20-alpine AS builder
WORKDIR /app

# Otimiza cache
COPY package*.json ./
# Se usar pnpm/yarn, troque o comando abaixo
RUN npm ci

# Copia o restante do código
COPY . .

# Detecta CRA (gera /build) ou Vite (gera /dist)
# Tenta 'npm run build'; falha se o script não existir
RUN npm run build

# =========================
# STAGE 2: Runtime (Nginx)
# =========================
FROM nginx:1.27-alpine

# Remove config default e adiciona nossa
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Copia artefatos gerados (CRA=build/ | Vite=dist/)
# Copia ambos; o que existir será usado
COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=builder /app/dist  /usr/share/nginx/html

# Se quiser healthcheck simples (opcional):
HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget -qO- http://127.0.0.1 || exit 1

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
