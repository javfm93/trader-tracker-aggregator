FROM node:18-slim

WORKDIR /code

COPY package*.json ./
RUN yarn

COPY . .
RUN yarn install
RUN npm run build
CMD npm run start
