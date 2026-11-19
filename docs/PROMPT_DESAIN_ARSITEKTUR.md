# Prompt untuk Claude — Desain Arsitektur Sistem SKETCHOO

Copy seluruh blok di bawah ini ke Claude.

---

Kamu adalah **software architect senior** yang berpengalaman merancang sistem edukasi mobile. Tugasmu: membuat dokumen **"Desain Arsitektur Sistem"** yang lengkap, konsisten, dan siap dipakai untuk laporan tugas akhir/proyek.

## Tujuan

Hasilkan SATU dokumen Markdown berbahasa Indonesia yang menjelaskan arsitektur sistem aplikasi **SKETCHOO** secara menyeluruh: high-level, container, komponen, data, alur (sequence), deployment, keamanan, dan non-functional requirements. Dokumen harus bisa langsung ditempel ke laporan/PDF.

## Konteks Produk

SKETCHOO adalah aplikasi edukasi untuk **anak usia dini** yang digunakan dengan pendampingan guru/orang tua. Fitur utama:

1. **Sketch Challenge** — anak menebalkan/menggambar pola, mendapat bintang dan unlock level.
2. **Jelajah Cilik** — mini-game edukatif: **Kenali Huruf** dan **Hitung Hewan**.
3. **Sketch-to-Story** — gambar anak diubah menjadi cerita anak.
4. **Missions** — daftar misi harian dengan progres.
5. **History** — riwayat karya anak (selesai/proses).
6. **Badges** — koleksi badge pencapaian.
7. **Profile** — profil anak/pendamping, kelas, statistik.
8. **Auth** — register, login email/password, login Google, verifikasi email, lupa sandi + kode reset.

## Stack yang Benar-Benar Ada (jangan diganti)

**Mobile (klien)**
- Flutter, Dart SDK `^3.13.4`, Material 3
- Arsitektur folder berlapis:
  - `lib/app/` — `app_router.dart` (routing), `app_dependencies.dart` (dependency injection), `session_store.dart` (JWT), `sketchoo_app.dart`
  - `lib/core/` — constants, theme, responsive, widgets, services (TTS), errors (`AppFailure`)
  - `lib/features/<fitur>/` — `screens/`, `widgets/`, `controllers/`, `models/`, `repositories/`, `services/`
  - `lib/data/remote/` — implementasi HTTP repository
  - `lib/data/mock/` — implementasi mock untuk development/test
- Pola: **Repository Pattern** + abstraksi interface, DI lewat `AppDependencies` (mode `mock` / `remote`).
- Package penting: `http`, `flutter_dotenv`, `shared_preferences`, `flutter_tts` (TTS on-device), `audioplayers`, `flutter_svg`, `google_sign_in`.
- Konfigurasi runtime dari `.env` (`API_BASE_URL`, `GOOGLE_WEB_CLIENT_ID`) yang dibundel sebagai asset.

**Backend**
- **NestJS** (REST API), base path `/api/v1`
- Dijalankan via **Docker Compose**, port `3000`
- Auth: JWT Bearer token; registrasi butuh verifikasi email
- Email transaksional: **Brevo** (disebut di README)
- Database: **PostgreSQL** via **Supabase** (asumsi — tandai sebagai asumsi bila tidak ada bukti)

**Pihak ketiga**
- Google Identity / OAuth 2.0 (login Google, ID token diverifikasi backend)
- Supabase (Auth/DB/Storage — sebutkan bagian yang dipakai, tandai yang belum pasti)
- Brevo (email verifikasi & reset password)

## Endpoint yang Sudah Ada di Kode Klien

| Method | Path | Fungsi |
|---|---|---|
| POST | `/auth/register` | Daftar akun baru, bisa mengembalikan `requires_email_confirmation` |
| POST | `/auth/login` | Login email/password, mengembalikan `{ user, access_token }` |
| POST | `/auth/google` | Login Google, body `{ id_token }` |
| POST | `/auth/resend-verification` | Kirim ulang email verifikasi |
| POST | `/auth/forgot-password` | Kirim kode reset |
| POST | `/auth/verify-reset-code` | Verifikasi kode, mengembalikan `reset_token` |
| POST | `/auth/reset-password` | Reset password dengan `reset_token` |
| GET | `/missions` | Daftar misi |
| GET | `/history?limit=100` | Riwayat karya |
| GET | `/sketch-challenge/levels` | Daftar level sketch challenge |
| POST | `/sketch-challenge/complete` | Simpan hasil level: `level_id`, `stroke_count`, `total_points`, `duration_seconds`, `artwork_image_url`, mengembalikan `stars_earned`, `score_added`, `total_stars`, `unlocked_level_id`, `feedback_message` |

Endpoint `POST /generate-story` pernah direncanakan tetapi **belum terverifikasi** — tandai **TBD/PROPOSED**, jangan anggap ada.

## Struktur Dokumen yang Diminta

Buat dengan urutan dan judul berikut:

1. **Ringkasan Eksekutif** — 1 paragraf + 3–5 poin arsitektur kunci.
2. **Tujuan, Ruang Lingkup, dan Aktor** — aktor: Anak, Pendamping/Guru, Admin (bila ada), sistem eksternal.
3. **Asumsi dan Hal yang Belum Pasti (TBD)** — daftar eksplisit, jangan disamarkan.
4. **Arsitektur High-Level (C4 Context)** — diagram Mermaid + penjelasan.
5. **Arsitektur Container (C4 Container)** — mobile app, API, database, storage, layanan eksternal; jelaskan tanggung jawab dan protokol komunikasi.
6. **Arsitektur Komponen**
   - 6.1 Klien Flutter: lapisan presentation → controller → repository → data source; jelaskan aliran data, DI, dan mode mock/remote.
   - 6.2 Backend NestJS: modul (Auth, Users, Missions, History, Sketch Challenge, Story), guard JWT, validasi DTO, error handling.
7. **Arsitektur Data**
   - ERD Mermaid dengan entitas minimal: `users`, `missions`, `user_missions`, `sketch_levels`, `sketch_attempts`/`artworks`, `history`, `badges`, `user_badges`, `stories`.
   - Atribut kunci, relasi, kardinalitas, dan catatan indeks/constraint.
   - Keputusan penyimpanan: apa di PostgreSQL, apa di Supabase Storage (gambar), format mana yang JSON.
8. **Alur Sistem (Sequence Diagram)** — Mermaid, minimal 5:
   - Register + verifikasi email
   - Login email/password
   - Login Google (Flutter → Google → backend → DB)
   - Menyelesaikan level Sketch Challenge
   - Sketch-to-Story (tandai bagian yang masih TBD)
   - Ambil missions & history (boleh digabung)
9. **Desain API** — tabel endpoint, request/response ringkas, status code, format error (`AppFailure`: `message`, `code`, `isRetryable`).
10. **Keamanan** — JWT (masa berlaku/refresh = TBD), penyimpanan token, Google ID token verification, HTTPS, rate limiting, validasi input, otorisasi per-user, secret management (service role key hanya di backend), privasi anak (UU PDP), parental consent.
11. **Penanganan Error, Offline, dan Ketahanan** — timeout, retry, fallback mock, degradasi fitur, idempotensi.
12. **Non-Functional Requirements** — performa, ketersediaan, skalabilitas, aksesibilitas anak, observability/logging, backup.
13. **Deployment** — diagram Mermaid (mobile → CDN/Play Store, backend container → VPS/Railway, DB Supabase, email Brevo, Google), environment dev/staging/prod, CI/CD singkat.
14. **Keputusan Teknologi & Alternatif** — tabel: pilihan, alasan, alternatif yang ditolak.
15. **Risiko dan Rencana Lanjutan** — teknis, keamanan, produk; prioritas.
16. **Lampiran** — daftar rute aplikasi, daftar folder proyek, glosarium.

Daftar rute klien (lampiran): `/splash`, `/onboarding`, `/login`, `/register`, `/forgot-password`, `/verify-reset-code`, `/verify-email`, `/home`, `/missions`, `/sketch-challenge`, `/sketch-challenge-levels`, `/jelajah-cilik`, `/jelajah-cilik/hitung-hewan`, `/jelajah-cilik/kenali-huruf`, `/sketch-to-story`, `/sketch-to-story/upload`, `/sketch-to-story/memproses`, `/sketch-to-story/hasil`, `/sketch-to-story/cerita`, `/history`, `/profile`, `/badges`, `/teacher`.

## Aturan Penulisan

- Bahasa Indonesia formal-teknis, ringkas, tanpa basa-basi.
- **Jangan mengarang** endpoint, tabel, atau layanan yang tidak ada di brief. Jika perlu, tulis eksplisit "Asumsi:" atau "TBD:".
- Semua diagram pakai **Mermaid** yang valid dan bisa dirender (hindari sintaks eksperimental). Beri judul diagram.
- Gunakan tabel untuk API, entitas data, dan keputusan teknologi.
- Setiap diagram wajib diikuti 2–5 kalimat penjelasan.
- Konsisten antara diagram dan teks (nama komponen, entitas, endpoint).
- Jangan menambahkan bagian di luar struktur di atas kecuali sub-bagian.
- Output hanya dokumen Markdown siap tempel, dimulai dari `# Desain Arsitektur Sistem — SKETCHOO`.

## Kriteria Selesai (periksa sebelum menjawab)

1. Semua 16 bagian ada.
2. Minimal 8 diagram Mermaid valid (context, container, 2 komponen, ERD, 5+ sequence, deployment).
3. Semua endpoint di tabel masuk ke desain API dan minimal satu sequence.
4. Asumsi dan TBD terdaftar, bukan disembunyikan.
5. Keamanan mencakup JWT, Google token, secret, dan privasi data anak.
6. Tidak ada entitas/endpoint fiktif yang disajikan sebagai fakta.
7. Dokumen bisa dibaca mandiri oleh dosen/reviewer tanpa akses repo.
