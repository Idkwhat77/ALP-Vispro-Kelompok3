# ALP Kelompok 3 – Semester 3 - Visual Programming & Web Development

## Anggota Kelompok
1. Michele Stevany Venda Dati  
2. A. Dewa Fortuna Mogot
3. Exsel Octaviand Gosal
4. Fernandes Howard
5. Vallerio Rayford Phoatmojo

Repository ini berisi proyek **aplikasi mobile full-stack** bernama **Clinter (Class Interactive)** yang dikembangkan sebagai bagian dari tugas **ALP Semester 3**. 
Clinter merupakan aplikasi pembelajaran interaktif yang dirancang untuk membantu guru meningkatkan keterlibatan dan interaksi sosial siswa di dalam kelas tanpa melibatkan penggunaan 
perangkat pribadi siswa.

Aplikasi ini menyediakan fitur permainan edukatif berbasis aktivitas kelas, seperti **Spin Wheel** dan **Charades**, yang mendorong partisipasi siswa melalui interaksi 
langsung dan penggunaan gerakan sebagai mekanisme permainan. Dari sisi teknis, aplikasi dibangun menggunakan **Flutter** sebagai frontend mobile dan **Laravel** sebagai backend API, 
dengan pemisahan arsitektur frontend dan backend untuk mendukung pengembangan yang terstruktur, mudah diuji, dan mudah dikembangkan. Aplikasi ini dirancang untuk dijalankan pada 
lingkungan lokal guna mendukung proses pengembangan dan pengujian.

---

## Teknologi yang Digunakan

### Backend

* PHP (Laravel Framework)
* Composer
* Database: SQLite 

### Frontend

* Flutter

---

## Struktur Proyek

```
.
├── Backend/                # Backend API menggunakan Laravel
│   ├── app/                # Logika aplikasi
│   ├── database/           # Migration dan seeder
│   ├── routes/             # API routes
│   └── .env.example        # Template konfigurasi environment
│
└── frontend/               # Aplikasi mobile Flutter
    ├── lib/                # Source code Dart
    ├── android/            # Konfigurasi Android
    ├── ios/                # Konfigurasi iOS
    └── pubspec.yaml        # Dependency Flutter
```

---

## Arsitektur
Aplikasi Clinter dikembangkan dengan pemisahan yang jelas antara frontend dan backend.  
Pada sisi frontend, aplikasi mobile dibangun menggunakan **Flutter** dengan pendekatan **BLoC (Business Logic Component)** untuk mengelola logika bisnis dan state aplikasi secara 
terstruktur dan berbasis event.

Pada sisi backend, sistem dikembangkan menggunakan **Laravel** dengan menerapkan arsitektur **Model-View-Controller (MVC)**. Arsitektur ini memisahkan pengelolaan data, 
logika aplikasi, dan penyajian respons API sehingga sistem lebih terorganisir dan mudah dikembangkan.

## Prasyarat

### Backend

* PHP sesuai kebutuhan Laravel
* Composer
* Laravel CLI

### Frontend

* Flutter SDK
* Dart SDK
* Firebase project

---

## Cara Menjalankan Proyek

### 1. Clone Repository

```bash
git clone https://github.com/Idkwhat77/ALP-Vispro-Kelompok3.git
```

---

### 2. Setup Backend

Masuk ke direktori backend:

```bash
cd Backend
```

Install dependency PHP:

```bash
composer install
```

Salin file environment dan generate key:

```bash
cp .env.example .env
php artisan key:generate
```

Jalankan server backend:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

API dapat diakses melalui:

```
http://127.0.0.1:8000
```

---

### 3. Setup Frontend

Kembali ke root project, lalu masuk ke folder frontend:

```bash
cd frontend
```

Install dependency Flutter:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

Pastikan backend sudah berjalan sebelum menjalankan aplikasi Flutter.

---

## Konfigurasi Koneksi API

* **Android Emulator** menggunakan:

  ```
  http://10.0.2.2:8000/api
  ```
* **iOS Simulator / perangkat fisik** menggunakan IP lokal komputer

Pastikan server Laravel dijalankan dengan host `0.0.0.0` agar dapat diakses oleh emulator atau perangkat.

---

## Troubleshooting Singkat

### Backend Tidak Bisa Terkoneksi Database

* Pastikan konfigurasi database di `.env` sudah benar
* Untuk SQLite:

  ```bash
  touch database/database.sqlite
  php artisan migrate
  ```

### Flutter Error / Build Gagal

```bash
flutter clean
flutter pub get
flutter doctor
```

---

## Lisensi

Proyek ini dikembangkan untuk keperluan akademik dan pembelajaran.
