# Nur Kitab - Aplikasi Islam Digital 

Aplikasi mobile berbasis **Flutter** yang dibuat untuk memenuhi tugas UAS akademik sekaligus berfungsi sebagai sarana dakwah digital komprehensif. Menyediakan akses cepat dan elegan ke Al-Qur'an, Dzikir harian, Sholawat, Maulid, serta penjadwalan ibadah yang sangat akurat. 

Desain aplikasi menggunakan tema gelap premium (*luxury dark theme* bergaya *glassmorphism*) untuk kenyamanan membaca di malam maupun siang hari, lengkap dengan kustomisasi antarmuka pengguna (UI).

## ✨ Fitur Utama

1. **Al-Qur'an Digital Terpadu** 
   - Daftar Surah lengkap dengan bingkai estetis (*stylized headers*) dan penyesuaian Basmalah otomatis (pengecualian untuk At-Taubah).
   - Navigasi berbasis **Juz** dengan kaligrafi bergaya "Juz Awwal".
   - Fitur cerdas **Lanjutkan Terakhir Dibaca** (*Last Read*) yang otomatis mendeteksi riwayat bacaan pengguna, baik di tingkat Surah maupun Juz.

2. **Kumpulan Sholawat, Maulid & Qashidah** 
   - **Sholawat**: Tibbil Qulub, Ilmi, Kamaliyah, Busyro, Badar.
   - **Maulid**: Barzanji Nadzom dan Maulid Diba'i yang interaktif (dilengkapi navigasi *Swipe/PageView* untuk berpindah antar 29 sub-pasalnya dengan mulus).
   - **Qashidah Burdah** dengan integrasi *font* kaligrafi ArefRuqaa.

3. **Hizib, Ratib & Munajat** 
   - Kumpulan wirid penjagaan diri seperti Ratib Al-Haddad, Ratib Al-Atthas, Hizib Bahar, Hizib Jailani, serta Munajat.

4. **Sistem Adzan & Jadwal Sholat Pintar (Offline-First)** 
   - Kalkulasi waktu sholat akurat *real-time* berbasis lokasi pengguna menggunakan ketetapan **Kementerian Agama RI (Metode 20)**.
   - **Notifikasi Adzan Penuh (*Insistent Alarm*)**: Suara adzan tidak terpotong dan berbunyi menyerupai alarm sistem (termasuk saat layar terkunci atau aplikasi ditutup).
   - Bekerja secara otomatis di kondisi **Offline**: Aplikasi mengunduh jadwal satu bulan penuh, dan menjadwalkan notifikasi hingga 7 hari ke depan ke dalam memori OS.
   - Terdapat **Pemutar Pratinjau (*Audio Preview*)** di menu Pengaturan yang memungkinkan pengguna mencoba suara *Adzan Kurdi Syeikh Mishary 1 & 2*.

5. **Kalender Islam & Jawa** 
   - Menampilkan tanggal Masehi, Hijriah, sekaligus hari **Pasaran Jawa** (Wage, Pon, Legi, Pahing, Kliwon) yang akurat dan *real-time* tepat di beranda aplikasi.

6. **Pengaturan Lanjutan & UI Dinamis**
   - Mode Gelap/Terang (*Theme Toggle*).
   - Penyesuaian Skala Huruf (*Font Size Skaler*).
   - Antarmuka Beranda eksklusif dengan kartu menu berdesain lengkung (*curved notch*) yang modern.

## 🛠 Teknologi yang Digunakan
- **Framework**: Flutter (Dart)
- **Local Storage**: SharedPreferences (untuk sistem *Offline-First* & *Caching* Jadwal)
- **Notifikasi**: `flutter_local_notifications` (Mode *Exact Alarm* & *Foreground Service*)
- **Pemutar Suara**: `audioplayers`
- **Lokasi & API**: `geolocator`, `geocoding`, API Aladhan v1

## 🚀 Cara Menjalankan Proyek
1. Pastikan **Flutter SDK** sudah terinstal.
2. *Clone repository* ini ke komputer Anda.
3. Jalankan `flutter pub get` di terminal untuk mengunduh seluruh ekstensi pustaka (*dependencies*).
4. Sambungkan *emulator* atau HP fisik Anda, lalu jalankan aplikasi dengan perintah `flutter run`.
