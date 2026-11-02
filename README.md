# curator

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Menjalankan dengan backend

`API_BASE_URL` dibaca dari `.env` (asset, jadi perubahan butuh rebuild, bukan
hot reload). Backend NestJS berjalan di port 3000.

| Target | `API_BASE_URL` | Catatan |
| --- | --- | --- |
| macOS / iOS Simulator | `http://localhost:3000/api/v1` | — |
| Android emulator | `http://localhost:3000/api/v1` | jalankan `adb reverse tcp:3000 tcp:3000` |
| HP Android via kabel | `http://localhost:3000/api/v1` | wajib `adb reverse tcp:3000 tcp:3000` |
| HP via Wi-Fi | `http://<IP-LAN-Mac>:3000/api/v1` | HP dan Mac di jaringan yang sama |

Untuk HP Android lewat kabel:

```bash
adb devices                       # pastikan device muncul & sudah authorize
adb reverse tcp:3000 tcp:3000     # ulangi setiap habis cabut/reconnect
flutter run -d <device-id>
```

Android sudah mengizinkan HTTP lokal (`usesCleartextTraffic="true"`). Untuk
iPhone fisik, tambahkan pengecualian ATS di `ios/Runner/Info.plist` sebelum
memakai `http://`.

