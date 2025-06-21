
FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8000

CMD ["npm", "start"] 

# Gunakan image Node.js LTS
FROM node:18

# Set direktori kerja di dalam container
WORKDIR /app

# Salin file konfigurasi terlebih dahulu
COPY package*.json ./

# Install dependency
RUN npm install

# Salin semua source code ke image
COPY . .

# Buka port yang digunakan server (misal 5000)
EXPOSE 5000

# Jalankan server
CMD ["npm", "start"]

