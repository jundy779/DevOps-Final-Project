# Panduan Instalasi

## Persyaratan Sistem
- Docker dan Docker Compose
- Node.js (versi 14 atau lebih baru)
- npm (versi 6 atau lebih baru)
- Git

## Langkah-langkah Instalasi

### 1. Clone Repository
```bash
git clone [URL_REPOSITORY]
cd voting-app
```

### 2. Setup Backend
```bash
cd backend
npm install
```

### 3. Setup Frontend
```bash
cd frontend
npm install
```

### 4. Konfigurasi Environment
Buat file `.env` di folder backend:
```
DB_HOST=db
DB_USER=voting_user
DB_PASSWORD=voting_pass
DB_NAME=voting_db
PORT=8000
```

### 5. Jalankan dengan Docker Compose
```bash
docker-compose up -d
```

## Verifikasi Instalasi

1. Cek status container:
```bash
docker-compose ps
```

2. Akses aplikasi:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000

## Troubleshooting

### Masalah Umum

1. **Port sudah digunakan**
   - Solusi: Hentikan service yang menggunakan port tersebut
   - Atau ubah port di `docker-compose.yml`

2. **Database connection error**
   - Solusi: Pastikan PostgreSQL container sudah running
   - Cek konfigurasi database di file `.env`

3. **Node modules error**
   - Solusi: Hapus folder `node_modules` dan `package-lock.json`
   - Jalankan `npm install` kembali 