# Dokumentasi API

## Endpoints

### 1. Mendapatkan Jumlah Vote
```http
GET /api/votes

Response:
{
    "candidates": [
        {
            "id": 1,
            "name": "Kandidat 1",
            "votes": 10
        },
        {
            "id": 2,
            "name": "Kandidat 2",
            "votes": 15
        }
    ]
}
```

### 2. Memberikan Vote
```http
POST /api/votes

Request Body:
{
    "candidate_id": 1
}

Response:
{
    "success": true,
    "message": "Vote berhasil disimpan"
}
```

## Contoh Penggunaan di Frontend

### 1. Mengambil Data Vote
```javascript
// Mengambil jumlah vote
async function getVotes() {
    const response = await fetch('http://localhost:8000/api/votes');
    const data = await response.json();
    return data.candidates;
}
```

### 2. Mengirim Vote
```javascript
// Mengirim vote
async function submitVote(candidateId) {
    const response = await fetch('http://localhost:8000/api/votes', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            candidate_id: candidateId
        })
    });
    return await response.json();
}
``` 