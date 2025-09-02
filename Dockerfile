
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./

RUN npm ci


COPY . .



RUN npm run build


FROM nginx:1.27-alpine


RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/app.conf


COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=builder /app/dist  /usr/share/nginx/html

HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget -qO- http://127.0.0.1 || exit 1

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
