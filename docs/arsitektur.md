# Arsitektur Sistem

## Diagram Arsitektur
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Frontend  │     │   Backend   │     │  Database   │
│  (React)    │◄────┤  (Node.js)  │◄────┤ (PostgreSQL)│
└─────────────┘     └─────────────┘     └─────────────┘
       ▲                   ▲
       │                   │
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│   Jenkins   │     │ Kubernetes  │
│   Pipeline  │     │  Cluster    │
└─────────────┘     └─────────────┘
```

## Komponen Sistem

### 1. Frontend (React)
- Port: 3000
- Fitur:
  - Menampilkan jumlah vote setiap kandidat
  - Button untuk memberikan vote
  - Mengirim data vote ke backend

### 2. Backend (Node.js)
- Port: 8000
- API Endpoints:
  - `GET /api/votes` - Mendapatkan jumlah vote setiap kandidat
  - `POST /api/votes` - Menyimpan vote baru

### 3. Database (PostgreSQL)
- Port: 5432
- Tabel:
  - votes (menyimpan data vote)

### 4. CI/CD Pipeline (Jenkins)
- Stages:
  - Build
  - Deploy

### 5. Container Orchestration (Kubernetes)
- Services:
  - frontend-service
  - backend-service
- Deployments:
  - frontend-deployment
  - backend-deployment

## Alur Aplikasi

1. **Menampilkan Jumlah Vote**
   - Backend mengambil data jumlah vote dari database
   - Frontend memanggil API untuk mendapatkan jumlah vote
   - Frontend menampilkan jumlah vote setiap kandidat

2. **Proses Voting**
   - User menekan button vote pada kandidat yang dipilih
   - Frontend mengirim data vote ke backend
   - Backend menyimpan data vote ke database
   - Jumlah vote diperbarui di tampilan

## Struktur Data

### Tabel Votes
```sql
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    candidate_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
``` 