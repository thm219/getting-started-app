FROM node:20-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
RUN npm install jest
CMD ["node", "./src/index.js"]

EXPOSE 3000