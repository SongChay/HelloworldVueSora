FROM node:12.19.1-alpine as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:1.20-alpine as dev-stage
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080:80
CMD  ["nginx", "-g", "daemon off;"]