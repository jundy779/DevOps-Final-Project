document.addEventListener('DOMContentLoaded', displayCandidates);

const API_URL = `http://${window.location.hostname}:8000/api`;

const loader = document.getElementById('loader');
const candidatesContainer = document.getElementById('candidates-container');
const alertContainer = document.getElementById('alert-container');

// Fungsi untuk menampilkan alert
function showAlert(message, type = 'danger') {
    const wrapper = document.createElement('div');
    wrapper.innerHTML = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;
    alertContainer.innerHTML = ''; // Hapus alert sebelumnya
    alertContainer.append(wrapper);

    // Hanya untuk notifikasi 'success', buat ia menghilang otomatis
    if (type === 'success') {
        const alert = wrapper.querySelector('.alert');
        setTimeout(() => {
            if (alert) {
                alert.classList.remove('show'); // Mulai animasi fade-out
                // Hapus elemen dari DOM setelah animasi selesai
                alert.addEventListener('transitionend', () => wrapper.remove());
            }
        }, 3000); // Hilang setelah 3 detik
    }
}

// Fungsi untuk mengambil data kandidat
async function getCandidates() {
    loader.style.display = 'block';
    candidatesContainer.style.display = 'none';
    try {
        const response = await fetch(`${API_URL}/votes`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        return data.candidates;
    } catch (error) {
        console.error('Error fetching candidates:', error);
        showAlert(`Gagal mengambil data kandidat: ${error.message}`);
        return null;
    } finally {
        loader.style.display = 'none';
        candidatesContainer.style.display = 'flex';
    }
}

// Fungsi untuk mengirim vote
async function submitVote(candidateId, button) {
    const originalButtonText = button.innerHTML;
    button.disabled = true;
    button.innerHTML = `
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        Memproses...
    `;

    try {
        const response = await fetch(`${API_URL}/votes`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ candidate_id: candidateId })
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        
        if (data.success) {
            showAlert('Vote berhasil disimpan!', 'success');
            // Refresh data setelah vote berhasil
            displayCandidates();
        } else {
            throw new Error(data.message || 'Gagal menyimpan vote dari server.');
        }
    } catch (error) {
        console.error('Error submitting vote:', error);
        showAlert(`Gagal mengirim vote: ${error.message}`);
        button.disabled = false;
        button.innerHTML = originalButtonText;
    }
}

// Fungsi untuk menampilkan kandidat
async function displayCandidates() {
    const candidates = await getCandidates();

    if (!candidates) {
        candidatesContainer.innerHTML = '<p class="text-center text-danger">Tidak dapat memuat data kandidat.</p>';
        return;
    }

    candidatesContainer.innerHTML = candidates.map(candidate => `
        <div class="col-md-6">
            <div class="card candidate-card h-100">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">${candidate.name}</h5>
                        <p class="card-text display-6 fw-bold">${candidate.votes}</p>
                    </div>
                    <button 
                        class="btn btn-primary btn-lg" 
                        onclick="submitVote(${candidate.id}, this)"
                    >
                        Vote <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    `).join('');
}

// Bootstrap JS, jika diperlukan untuk komponen seperti dismissible alerts
const bootstrapScript = document.createElement('script');
bootstrapScript.src = "https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js";
document.body.appendChild(bootstrapScript); 