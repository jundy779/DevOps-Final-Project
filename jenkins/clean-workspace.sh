#!/bin/bash

# 🧹 Script untuk membersihkan Jenkins workspace
# Jalankan script ini di server Jenkins jika ada masalah permission

echo "🧹 Membersihkan Jenkins workspace..."

# Cek apakah script dijalankan sebagai root atau jenkins user
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Script dijalankan sebagai root"
    JENKINS_USER="jenkins"
    JENKINS_HOME="/var/lib/jenkins"
else
    echo "✅ Script dijalankan sebagai user biasa"
    JENKINS_USER="$USER"
    JENKINS_HOME="$HOME"
fi

echo "👤 User: $JENKINS_USER"
echo "🏠 Jenkins Home: $JENKINS_HOME"

# Daftar workspace yang perlu dibersihkan
WORKSPACES=(
    "backend-pipeline"
    "frontend-pipeline"
    "voting-app-pipeline"
)

# Fungsi untuk membersihkan workspace
clean_workspace() {
    local workspace="$1"
    local workspace_path="$JENKINS_HOME/workspace/$workspace"
    
    echo "🧹 Membersihkan workspace: $workspace"
    
    if [ -d "$workspace_path" ]; then
        echo "📁 Workspace ditemukan: $workspace_path"
        
        # Coba hapus dengan rm biasa
        if rm -rf "$workspace_path" 2>/dev/null; then
            echo "✅ Workspace berhasil dibersihkan"
        else
            echo "⚠️  Gagal dengan rm biasa, coba dengan sudo..."
            
            # Jika gagal, coba dengan sudo
            if sudo rm -rf "$workspace_path" 2>/dev/null; then
                echo "✅ Workspace berhasil dibersihkan dengan sudo"
            else
                echo "❌ Gagal membersihkan workspace: $workspace"
                echo "   Coba manual: sudo rm -rf $workspace_path"
            fi
        fi
    else
        echo "ℹ️  Workspace tidak ditemukan: $workspace"
    fi
}

# Fungsi untuk membersihkan semua workspace
clean_all_workspaces() {
    echo "🧹 Membersihkan semua workspace..."
    
    for workspace in "${WORKSPACES[@]}"; do
        clean_workspace "$workspace"
        echo "---"
    done
}

# Fungsi untuk membersihkan cache Git
clean_git_cache() {
    echo "🧹 Membersihkan Git cache..."
    
    local git_cache="$JENKINS_HOME/.git"
    if [ -d "$git_cache" ]; then
        echo "📁 Git cache ditemukan: $git_cache"
        if rm -rf "$git_cache" 2>/dev/null; then
            echo "✅ Git cache berhasil dibersihkan"
        else
            echo "⚠️  Gagal membersihkan Git cache"
        fi
    else
        echo "ℹ️  Git cache tidak ditemukan"
    fi
}

# Fungsi untuk restart Jenkins
restart_jenkins() {
    echo "🔄 Restart Jenkins..."
    
    if command -v systemctl >/dev/null 2>&1; then
        echo "📦 Menggunakan systemctl..."
        sudo systemctl restart jenkins
    elif command -v service >/dev/null 2>&1; then
        echo "📦 Menggunakan service..."
        sudo service jenkins restart
    else
        echo "⚠️  Tidak dapat restart Jenkins otomatis"
        echo "   Restart manual: sudo systemctl restart jenkins"
    fi
}

# Main execution
echo "🚀 MULAI PEMBERSIHAN JENKINS WORKSPACE"
echo "======================================"

# Pilihan menu
echo ""
echo "Pilih opsi:"
echo "1. Bersihkan workspace backend-pipeline"
echo "2. Bersihkan workspace frontend-pipeline"
echo "3. Bersihkan workspace voting-app-pipeline"
echo "4. Bersihkan semua workspace"
echo "5. Bersihkan Git cache"
echo "6. Restart Jenkins"
echo "7. Bersihkan semuanya + Restart"
echo "8. Keluar"
echo ""

read -p "Masukkan pilihan (1-8): " choice

case $choice in
    1) clean_workspace "backend-pipeline" ;;
    2) clean_workspace "frontend-pipeline" ;;
    3) clean_workspace "voting-app-pipeline" ;;
    4) clean_all_workspaces ;;
    5) clean_git_cache ;;
    6) restart_jenkins ;;
    7) 
        clean_all_workspaces
        clean_git_cache
        restart_jenkins
        ;;
    8) 
        echo "👋 Sampai jumpa!"
        exit 0
        ;;
    *) 
        echo "❌ Pilihan tidak valid!"
        exit 1
        ;;
esac

echo ""
echo "✅ Pembersihan selesai!"
echo "🔄 Sekarang coba jalankan pipeline Jenkins lagi" 