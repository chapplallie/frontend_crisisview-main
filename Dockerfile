FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json /app
RUN npm ci

COPY . .

RUN npm run build && npm run export

FROM nginx:stable-alpine3.20-slim AS runtime

COPY --from=builder /app/out /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
