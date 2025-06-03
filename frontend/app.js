// Konfigurasi API
const API_URL = 'http://localhost:8000/api';

// Fungsi untuk mengambil data kandidat dan jumlah vote
async function getCandidates() {
    try {
        const response = await fetch(`${API_URL}/votes`);
        const data = await response.json();
        return data.candidates;
    } catch (error) {
        console.error('Error:', error);
        alert('Gagal mengambil data kandidat');
    }
}

// Fungsi untuk mengirim vote
async function submitVote(candidateId) {
    try {
        const response = await fetch(`${API_URL}/votes`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                candidate_id: candidateId
            })
        });

        const data = await response.json();
        
        if (data.success) {
            alert('Vote berhasil disimpan!');
            // Refresh data setelah vote berhasil
            displayCandidates();
        } else {
            alert('Gagal menyimpan vote');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Gagal mengirim vote');
    }
}

// Fungsi untuk menampilkan kandidat
async function displayCandidates() {
    const container = document.getElementById('candidates-container');
    const candidates = await getCandidates();

    if (!candidates) return;

    container.innerHTML = candidates.map(candidate => `
        <div class="candidate-card">
            <div>
                <div class="candidate-name">${candidate.name}</div>
                <div class="vote-count">${candidate.votes} votes</div>
            </div>
            <button 
                class="vote-button" 
                onclick="submitVote(${candidate.id})"
            >
                Vote
            </button>
        </div>
    `).join('');
}

// Load data saat halaman dibuka
document.addEventListener('DOMContentLoaded', displayCandidates); 