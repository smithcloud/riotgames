# FROM node:23.4.0
# COPY . .
# RUN npm install react-scripts
# ENV NODE_OPTIONS=--openssl-legacy-provider
# ENV CI=true
# EXPOSE 3001
# CMD ["npm","run","start"]

# FROM nginx:1.17
# COPY build/ /usr/share/nginx/html 

FROM node:lts as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build
FROM nginx:latest
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
