# syntax=docker/dockerfile:1

ARG NODE_VERSION=22.14.0
FROM node:${NODE_VERSION}-alpine

# Ganti ke development
ENV NODE_ENV=development

# Direktori kerja
WORKDIR /app

# Salin file dependency
COPY package*.json ./

# Install semua dependency termasuk dev
RUN npm install

# Salin semua source code
COPY . .

# Expose port
EXPOSE 3000

# Jalankan server dev (Next.js / nodemon / Express)
CMD ["npm", "run", "dev"]
