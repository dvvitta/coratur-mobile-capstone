# SKETCHOO Mobile

Aplikasi mobile SKETCHOO berbasis Flutter. Backend utama adalah NestJS; aplikasi mengaksesnya lewat REST API.

## Persiapan setelah clone

1. Pastikan Flutter tersedia. Project ini memerlukan Dart SDK 3.13.4 atau lebih baru sesuai batas di `pubspec.yaml`.
2. Buat konfigurasi lokal dari template:

   ```powershell
   Copy-Item .env.example .env
   ```

3. Atur `API_BASE_URL` di `.env` sesuai perangkat:
   - Android Emulator: `http://10.0.2.2:3000/api/v1`.
   - Windows/Web atau iOS Simulator: `http://localhost:3000/api/v1`.
   - Android via USB: gunakan `http://localhost:3000/api/v1`, lalu jalankan `adb reverse tcp:3000 tcp:3000`.
   - HP Android via Wi-Fi: gunakan IP LAN komputer, misalnya `http://192.168.1.10:3000/api/v1`; keduanya harus di jaringan yang sama.
4. Jalankan backend NestJS dari folder repo backend dengan `docker compose up --build -d`; pastikan port 3000 aktif.
5. Dari folder mobile jalankan:

   ```sh
   flutter pub get
   flutter run
   ```

`API_BASE_URL` dibaca dari `.env` yang dibundel sebagai asset Flutter. Perubahan `.env` perlu full restart/rebuild, bukan hot reload. File `.env` di-ignore Git dan hanya berisi URL API—jangan taruh Supabase secret key atau kredensial Brevo di aplikasi mobile.

## Pemeriksaan

```sh
flutter analyze
flutter test
```

## Menjalankan di Android via USB

```sh
adb devices
adb reverse tcp:3000 tcp:3000
flutter run -d <device-id>
```

Ulangi `adb reverse` setelah perangkat dicabut atau tersambung kembali. Android sudah mengizinkan HTTP lokal lewat `usesCleartextTraffic`; untuk iPhone fisik, tambahkan pengecualian ATS di `ios/Runner/Info.plist` sebelum menggunakan `http://`.
