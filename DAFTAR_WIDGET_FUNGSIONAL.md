# DOKUMENTASI LENGKAP: DAFTAR WIDGET PROYEK SKETCHOO
Rangkuman seluruh file komponen di dalam folder `widgets/` beserta fungsi teknisnya.

---

## 1. GLOBAL & CORE WIDGETS (`lib/core/widgets/`)

### `curator_bottom_nav.dart`
* **Lokasi:** `lib/core/widgets/curator_bottom_nav.dart`
* **Fungsi:** Komponen bilah navigasi bawah (*Bottom Navigation Bar*) kustom 3 tab (`Home`, `History`, `Profile`).
* **Fitur UI:** Menggunakan `AnimatedPositioned` untuk menggeser kapsul indikator ungu (`#6D3FE0`) secara horizontal mengikuti tab yang diklik. Menampilkan teks label hanya pada tab yang sedang aktif.

### `structure_placeholder_page.dart`
* **Lokasi:** `lib/core/widgets/structure_placeholder_page.dart`
* **Fungsi:** Halaman sementara (*stub placeholder*) saat tahap pembuatan rute baru sebelum UI fitur aslinya selesai diimplementasikan. Mencegah error routing rute kosong.

---

## 2. ONBOARDING WIDGETS (`lib/features/onboarding/widgets/`)

### `onboarding_page_content.dart`
* **Lokasi:** `lib/features/onboarding/widgets/onboarding_page_content.dart`
* **Fungsi:** Komponen render visual tunggal di dalam `PageView` Onboarding.
* **Fitur UI:** Menggabungkan gambar ilustrasi anak dengan lapisan bawah lingkaran pendar cahaya ungu lembut (`RadialGradient`) agar ilustrasi menonjol di atas latar putih.

### `onboarding_colors.dart`
* **Lokasi:** `lib/features/onboarding/widgets/onboarding_colors.dart`
* **Fungsi:** Menyimpan konstanta palet warna khusus alur Onboarding (warna judul `#2E2A4A`, body `#757095`, aksen ungu `#5837B7`, dan warna titik nonaktif `#E5E0F4`).

---

## 3. AUTHENTICATION WIDGETS (`lib/features/authentication/widgets/`)

### `auth_form_sheet.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_form_sheet.dart`
* **Fungsi:** Kartu putih melengkung (radius 36) yang memuat seluruh formulir login dan pendaftaran.
* **Fitur UI:** 
  - Mengatur transisi ukuran otomatis via `AnimatedSize` saat berganti tab.
  - Memposisikan maskot gajah di atas kurva kartu putih secara presisi (rumus rasio 1089/1536).
  - Mengelola form nama, email, password, konfirmasi password, checkbox ingat saya, pemisah "Atau", dan tombol Google.

### `auth_tabs.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_tabs.dart`
* **Fungsi:** Tombol sakelar ganda (*segmented switch*) untuk memilih mode antara **"Masuk"** dan **"Daftar"**.
* **Fitur UI:** Membungkus dua tab chip dalam satu trek abu-abu muda (`#F1EDFC`), tab yang terpilih berubah warna putih dengan elevasi bayangan halus.

### `auth_text_field.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_text_field.dart`
* **Fungsi:** Komponen input formulir seragam untuk Nama, Email, dan Password.
* **Fitur UI:** Memiliki label di atas kotak, tanda bintang merah jika wajib diisi (`*`), border halus `#E6E1F7`, border fokus ungu `#6B4DFF`, serta slot ikon depan (*prefix*) dan tombol toggle intip password (*suffix*).

### `auth_primary_button.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_primary_button.dart`
* **Fungsi:** Tombol aksi utama ("Masuk" / "Daftar") bergradasi ungu.
* **Fitur UI:** Menggunakan `DecoratedBox` bergradasi 3 warna (`#B9A4FF` ➔ `#8B6CFF` ➔ `#6E4DFF`), bayangan ungu menyala, serta indikator loading lingkaran (`CircularProgressIndicator`) saat data sedang dikirim ke server.

### `auth_scroll_view.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_scroll_view.dart`
* **Fungsi:** Pembungkus `ListView` khusus layar autentikasi yang mematikan efek tarikan karet overscroll Android (`overscroll: false`). Menjaga tampilan background tetap stabil saat formulir di-scroll.

### `auth_elephant.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_elephant.dart`
* **Fungsi:** Komponen pembungkus gambar maskot gajah login/register (`AssetPaths.authElephant`) dengan proteksi rasio aspek 1.5 (1024x1536) dan fallback error handling.

### `google_logo.dart`
* **Lokasi:** `lib/features/authentication/widgets/google_logo.dart`
* **Fungsi:** Komponen logo Google resmi 4-warna (*Merah, Kuning, Hijau, Biru*).
* **Fitur UI:** Digambar manual menggunakan `CustomPainter` murni tanpa aset gambar eksternal, sehingga tidak pecah pada resolusi tinggi dan bebas latensi muat file.

### `auth_colors.dart`
* **Lokasi:** `lib/features/authentication/widgets/auth_colors.dart`
* **Fungsi:** Kamus konstanta palet warna khusus alur autentikasi (warna teks judul, border input, track tab, dan warna bayangan kartu).

### `forgot_password_elephant.dart`
* **Lokasi:** `lib/features/authentication/widgets/forgot_password_elephant.dart`
* **Fungsi:** Komponen gambar gajah lama untuk layar lupa password. *(Catatan: Pada desain terbaru telah digantikan oleh SVG transparan di `forgot_password_screen.dart`).*

---

## 4. SKETCH CHALLENGE WIDGETS (`lib/features/sketch_challenge/widgets/`)

### `sketch_canvas_painter.dart`
* **Lokasi:** `lib/features/sketch_challenge/widgets/sketch_canvas_painter.dart`
* **Fungsi:** Engine menggambar berbasis `CustomPainter` native Flutter.
* **Fitur Teknis:**
  - Mengambil daftar garis `List<DrawnLine>`.
  - Menggambar sapuan kuas digital memakai kurva Bézier `Path` dengan ujung tumpul membulat (`StrokeCap.round`, `StrokeJoin.round`).
  - Menangani tap 1 titik menjadi lingkaran kecil (`drawCircle`) dan goresan jemari panjang menjadi garis kurva kontinu (`drawPath`).

---

## 5. MISSIONS WIDGETS (`lib/features/missions/widgets/`)

### `mission_card.dart`
* **Lokasi:** `lib/features/missions/widgets/mission_card.dart`
* **Fungsi:** Komponen kartu item misi harian.
* **Fitur UI:**
  - Menampilkan ikon misi (krayon atau buku), judul, dan deskripsi hadiah EXP/koin.
  - Membedakan warna background secara otomatis: hijau lembut (`#EDFBF1`) jika misi sudah selesai, atau kuning krem (`#FEF8E3`) jika misi masih berjalan.
  - Memiliki tombol checklist atau klaim di sisi kanan.

---

## RINGKASAN PEMBAGIAN TUGAS

| Kategori | File Widget | Tanggung Jawab Utama |
| :--- | :--- | :--- |
| **Global** | `curator_bottom_nav.dart` | Bilah navigasi 3 tab dengan pill indikator animasi geser |
| **Global** | `structure_placeholder_page.dart` | Halaman placeholder sementara untuk rute pengembangan |
| **Onboarding**| `onboarding_page_content.dart` | Render halaman ilustrasi carousel dengan lingkaran glow |
| **Onboarding**| `onboarding_colors.dart` | Definisi warna khusus onboarding |
| **Auth** | `auth_form_sheet.dart` | Wadah formulir login/daftar + penempatan posisi gajah |
| **Auth** | `auth_tabs.dart` | Sakelar segmented chip tab Masuk vs Daftar |
| **Auth** | `auth_text_field.dart` | Input teks seragam (border, validasi, toggle password) |
| **Auth** | `auth_primary_button.dart` | Tombol utama gradasi ungu + status spinner loading |
| **Auth** | `auth_scroll_view.dart` | Scroll view anti-stretch untuk form autentikasi |
| **Auth** | `auth_elephant.dart` | Pemanggil aset gambar maskot gajah |
| **Auth** | `google_logo.dart` | Gambar vektor 4 warna logo Google via CustomPainter |
| **Auth** | `auth_colors.dart` | Definisi warna khusus autentikasi |
| **Auth** | `forgot_password_elephant.dart` | Komponen visual gajah lupa password |
| **Sketch** | `sketch_canvas_painter.dart` | Engine render goresan kuas garis jari di kanvas |
| **Missions** | `mission_card.dart` | Kartu daftar misi dengan status selesai/belum |
