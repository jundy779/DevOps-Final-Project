# 🚀 Voting App DevOps Project - Panduan Sederhana

## 📖 Apa Ini?

Ini adalah aplikasi voting sederhana yang dibuat untuk belajar DevOps. Aplikasi terdiri dari:
- **Website** untuk memilih kandidat
- **Server** untuk mengolah data voting  
- **Database** untuk menyimpan data

## 🎯 Yang Akan Kamu Pelajari

- ✅ Docker (membungkus aplikasi)
- ✅ Kubernetes (menjalankan di server)
- ✅ Jenkins (otomatisasi build & deploy)
- ✅ Monitoring (melihat performa aplikasi)

## 🚀 Cara Cepat Mulai (5 Menit)

### Windows
```powershell
# 1. Setup semua yang diperlukan
.\setup-untuk-awam.ps1

# 2. Jalankan aplikasi
.\jalankan-aplikasi.ps1
```

### Linux/macOS
```bash
# 1. Setup semua yang diperlukan
chmod +x setup-untuk-awam.sh
./setup-untuk-awam.sh

# 2. Jalankan aplikasi
chmod +x jalankan-aplikasi.sh
./jalankan-aplikasi.sh
```

## 🐳 Cara Paling Mudah - Docker Compose

```bash
# Jalankan aplikasi
docker-compose up -d

# Buka browser
# Frontend: http://localhost:3000
# Backend: http://localhost:8000
```

## 📋 Menu Pilihan

Ketika menjalankan script, kamu akan melihat menu seperti ini:

```
╔══════════════════════════════════════════════════════════════╗
║                    VOTING APP DEVOPS PROJECT                ║
║                   SCRIPT JALANKAN APLIKASI                 ║
╚══════════════════════════════════════════════════════════════╝

PILIH CARA MENJALANKAN APLIKASI:

1. 🐳 Docker Compose (Paling Mudah)
2. ☸️  Kubernetes (Production-like)
3. 🔧 Jenkins CI/CD
4. 📊 Monitoring (Prometheus + Grafana)
5. 🛑 Stop Semua Aplikasi
6. ❌ Keluar
```

## 🎮 Cara Menggunakan

### 1. Docker Compose (Paling Mudah)
- Pilih opsi 1
- Tunggu aplikasi siap
- Buka http://localhost:3000 di browser
- Mulai voting!

### 2. Kubernetes (Seperti Production)
- Pilih opsi 2
- Tunggu deployment selesai
- Jalankan port forward untuk akses

### 3. Jenkins (CI/CD)
- Pilih opsi 3
- Buka http://localhost:8080
- Setup pipeline untuk otomatisasi

### 4. Monitoring (Lihat Performa)
- Pilih opsi 4
- Buka http://localhost:3001 (Grafana)
- Lihat metrics aplikasi

## 🔧 Troubleshooting

### Aplikasi Tidak Bisa Dibuka
```bash
# Cek apakah container jalan
docker-compose ps

# Lihat logs
docker-compose logs

# Restart aplikasi
docker-compose restart
```

### Port Sudah Terpakai
```bash
# Cek port yang digunakan
netstat -tulpn | grep :3000
netstat -tulpn | grep :8000

# Stop aplikasi lain yang menggunakan port
docker-compose down
```

### Docker Tidak Ada
```bash
# Install Docker Desktop dari:
# https://www.docker.com/products/docker-desktop/
```

## 📚 Belajar Lebih Lanjut

### Dokumentasi Lengkap
- [Panduan Lengkap untuk Awam](docs/PANDUAN_LENGKAP_UNTUK_AWAM.md)
- [Arsitektur Aplikasi](docs/architecture.md)
- [API Documentation](docs/api-dokumentasi.md)

### Video Tutorial
- [Docker Tutorial](https://www.youtube.com/watch?v=3c-iBn73dDE)
- [Kubernetes Tutorial](https://www.youtube.com/watch?v=s_o8dwzRlu4)
- [Jenkins Tutorial](https://www.youtube.com/watch?v=89yWXXIOisk)

### Tools Online
- [Docker Playground](https://labs.play-with-docker.com/)
- [Kubernetes Playground](https://www.katacoda.com/courses/kubernetes)
- [Jenkins Blue Ocean](https://www.jenkins.io/projects/blueocean/)

## 🆘 Butuh Bantuan?

### Error Umum
1. **"Docker tidak ditemukan"**
   - Install Docker Desktop
   - Restart komputer

2. **"Port sudah terpakai"**
   - Stop aplikasi lain
   - Gunakan port berbeda

3. **"Permission denied"**
   - Jalankan sebagai Administrator (Windows)
   - Gunakan sudo (Linux)

### Sumber Bantuan
- 📖 Baca dokumentasi di folder `docs/`
- 🔍 Google error message
- 💬 Tanya di Stack Overflow
- 🐛 Buat issue di GitHub

## 🎉 Selamat!

Kamu sudah berhasil menjalankan aplikasi DevOps! 

### Langkah Selanjutnya
1. **Eksplorasi aplikasi** - coba fitur voting
2. **Modifikasi kode** - ubah tampilan atau logika
3. **Deploy ke cloud** - gunakan AWS, GCP, atau Azure
4. **Tambah fitur** - buat aplikasi lebih kompleks

### Tips
- Mulai dengan Docker Compose (paling mudah)
- Pelajari satu teknologi dulu sebelum lanjut
- Jangan takut error - itu bagian dari belajar!
- Dokumentasikan setiap langkah

---

**Happy Learning! 🚀**

Jika proyek ini membantu, jangan lupa ⭐ repository ini! 