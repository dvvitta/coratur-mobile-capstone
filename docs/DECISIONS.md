# Keputusan SKETCHOO

Status memakai label PRD: APPROVED, PROPOSED, TBD, MOCK, DEFERRED, VERIFIED.

| Area | Status | Keputusan |
|---|---|---|
| Framework | APPROVED | Flutter + Dart |
| Target pertama | APPROVED | Android smartphone |
| Target sekunder | APPROVED | Flutter Web setelah pengujian |
| Bahasa UI | APPROVED | Bahasa Indonesia |
| State management | TBD | Belum dipilih; template awal tidak memakai package tambahan |
| Mode aplikasi default | MOCK | `AppDependencies.development()` memakai `AppEnvironment.mock` |
| Backend/auth/AI | PROPOSED / TBD | Belum terhubung |
| Aset visual | TBD | Folder `assets/` sudah ada; file desain belum ditempatkan |
| Splash intro | APPROVED | Putih → fade logo (`assets/images/logo.png`) → logo naik + background `assets/images/full screen splash 3.png`. Frame `assets/illustrations/splash 1-3.png` hanya referensi. |
| Rute setelah splash | MOCK | Tidak ada persistence; selalu ke `/onboarding` |
| Onboarding | APPROVED | 3 halaman dari `assets/images/onboardd 1-3.png`; teks dari frame illustrations. Tombol Lewati di semua halaman (desain 2 dan 3 tidak punya, ditambah atas permintaan). CTA akhir/Lewati → `/login` (placeholder). Persistence onboarding TBD. |
| Login/Daftar | APPROVED | Satu layar tab sesuai `login 2.png` dan `regist.png`. Kartu slide dari bawah. Gajah `gajah login regris.png`. Auth MOCK; Google belum terhubung (pesan jujur). |
| Struktur folder | APPROVED | Feature-first sesuai PRD bagian 6 |

Catatan aset: file gambar disimpan di `assets/` (akar proyek), bukan `lib/assets/`. Folder `lib/assets/` disiapkan untuk mapping path jika jumlah aset sudah banyak.
