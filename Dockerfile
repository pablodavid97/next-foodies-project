FROM node:20 AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

ARG NEXT_PUBLIC_IMAGE_URL
ENV NEXT_PUBLIC_IMAGE_URL=${NEXT_PUBLIC_IMAGE_URL}
RUN npm run build

RUN npm prune --production

FROM node:20 AS runner

WORKDIR /app

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js

EXPOSE 3000

CMD ["npm", "start"]


