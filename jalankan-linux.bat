@echo off
REM 🚀 Windows Batch Script untuk menjalankan Linux Scripts
REM Script ini akan menjalankan script bash menggunakan WSL atau Git Bash

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    VOTING APP DEVOPS PROJECT                ║
echo ║                   WINDOWS BATCH SCRIPT                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Cek apakah WSL tersedia
where wsl >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ WSL ditemukan, menggunakan WSL...
    echo.
    echo Pilih opsi:
    echo 1. Setup semua komponen
    echo 2. Jalankan aplikasi
    echo 3. Keluar
    echo.
    set /p choice="Masukkan pilihan (1-3): "
    
    if "%choice%"=="1" (
        echo.
        echo 🚀 Menjalankan setup script...
        wsl bash setup-untuk-awam.sh
    ) else if "%choice%"=="2" (
        echo.
        echo 🚀 Menjalankan aplikasi...
        wsl bash jalankan-aplikasi.sh
    ) else if "%choice%"=="3" (
        echo 👋 Sampai jumpa!
        exit /b 0
    ) else (
        echo ❌ Pilihan tidak valid!
        pause
        exit /b 1
    )
) else (
    REM Cek apakah Git Bash tersedia
    where bash >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ Git Bash ditemukan, menggunakan Git Bash...
        echo.
        echo Pilih opsi:
        echo 1. Setup semua komponen
        echo 2. Jalankan aplikasi
        echo 3. Keluar
        echo.
        set /p choice="Masukkan pilihan (1-3): "
        
        if "%choice%"=="1" (
            echo.
            echo 🚀 Menjalankan setup script...
            bash setup-untuk-awam.sh
        ) else if "%choice%"=="2" (
            echo.
            echo 🚀 Menjalankan aplikasi...
            bash jalankan-aplikasi.sh
        ) else if "%choice%"=="3" (
            echo 👋 Sampai jumpa!
            exit /b 0
        ) else (
            echo ❌ Pilihan tidak valid!
            pause
            exit /b 1
        )
    ) else (
        echo ❌ WSL atau Git Bash tidak ditemukan!
        echo.
        echo Untuk menjalankan script Linux di Windows, kamu perlu:
        echo 1. Install WSL (Windows Subsystem for Linux)
        echo    - Buka PowerShell sebagai Administrator
        echo    - Jalankan: wsl --install
        echo.
        echo ATAU
        echo.
        echo 2. Install Git for Windows (termasuk Git Bash)
        echo    - Download dari: https://git-scm.com/download/win
        echo.
        echo ATAU
        echo.
        echo 3. Gunakan script PowerShell yang sudah tersedia:
        echo    - setup-untuk-awam.ps1
        echo    - jalankan-aplikasi.ps1
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ✅ Script selesai!
pause 