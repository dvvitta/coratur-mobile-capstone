# SKETCHOO — Product Requirements Document (PRD)
**Versi:** 1.0  
**Status:** Baseline implementasi frontend dengan arsitektur siap integrasi  
**Target coding agent:** Cursor (berlaku juga untuk agent coding lain)  
**Bahasa aplikasi:** Bahasa Indonesia  
**Platform utama:** Flutter Android; Flutter Web untuk browser desktop/Smartboard sebagai target sekunder

---

## 0. Instruksi utama untuk AI coding agent

Baca dokumen ini sebelum mengubah kode. Repository dan aset desain yang sudah ada adalah sumber kebenaran bersama dokumen ini.

**Kondisi proyek saat ini:** UI/UX masih menjadi fokus utama. Sebagian besar logic bisnis, backend, database, autentikasi produksi, computer vision, dan generasi cerita belum terhubung. Jangan berpura-pura integrasi tersebut sudah ada. Bangun frontend yang bisa didemokan dengan data mock yang jelas, sambil memisahkan semua dependency eksternal melalui interface/service/repository agar integrasi nyata nanti dapat ditambahkan tanpa menulis ulang seluruh UI.

### Aturan wajib
1. **Inspect before coding.** Periksa struktur repository, `pubspec.yaml`, aset, router, state management, dan implementasi yang sudah ada. Jangan mengasumsikan proyek masih kosong.
2. **Jangan merusak desain yang disetujui.** Gunakan screenshot/Figma yang diberikan sebagai referensi visual. Jangan mengubah warna, ilustrasi, teks, komposisi, radius, spacing, atau navigasi tanpa alasan dan persetujuan.
3. **Jangan membuat ulang seluruh proyek.** Lakukan perubahan kecil dan terarah. Pertahankan kode yang sudah bekerja.
4. **Tidak ada tombol palsu.** Setiap tombol harus menjalankan aksi yang masuk akal. Jika backend belum tersedia, gunakan mock flow yang diberi label development, atau nonaktifkan tombol dengan keterangan yang jelas.
5. **Pisahkan UI dan logic.** Widget tidak boleh langsung memanggil Gemini, Supabase, HTTP, file system, atau database. Gunakan controller/view-model/use case dan service/repository.
6. **Integrasi harus plug-and-play.** UI bergantung pada kontrak abstrak seperti `AuthRepository`, `LearningSessionRepository`, `ImageRecognitionService`, dan `StoryGenerationService`. Implementasi mock dapat diganti implementasi nyata lewat dependency injection/configuration.
7. **Jangan mengarang.** Jangan membuat API endpoint, skema database, credentials, package, model AI, atau hasil tes yang tidak benar-benar ada. Informasi yang belum diputuskan diberi label `TBD`.
8. **Rahasia tidak boleh ada di aplikasi client.** Jangan memasukkan Gemini API key, service-role key Supabase, password, atau secret ke Flutter, assets, commit, screenshot, atau log.
9. **Jaga privasi anak.** Gunakan data contoh fiktif. Jangan log gambar, token, password, atau informasi identitas anak.
10. **Tes dan laporkan secara jujur.** Jalankan formatter, analyzer, dan test yang relevan. Jangan mengklaim tes/build berhasil jika perintah tidak dijalankan.
11. **Jangan menambah dependency atau arsitektur berlebihan.** Periksa apakah package atau komponen serupa sudah ada sebelum menambahkan yang baru.
12. **Satu task per perubahan.** Jika permintaan besar, pecah menjadi milestone. Jangan melakukan refactor besar yang tidak diperlukan.

### Laporan akhir setiap task
- Tujuan perubahan.
- File yang dibuat/diubah.
- Perilaku yang sudah bekerja.
- Perintah tes yang benar-benar dijalankan dan hasilnya.
- Bagian yang masih mock/TBD/belum diuji.
- Risiko atau keputusan yang dibutuhkan.
- Satu langkah berikutnya yang direkomendasikan.

---

## 1. Ringkasan produk

SKETCHOO adalah aplikasi edukasi untuk anak usia dini yang memadukan latihan menggambar/menelusuri pola, mini-game pembelajaran, dan pembuatan fabel dari gambar. Aplikasi dirancang untuk digunakan anak dengan pendampingan guru/orang tua.

### Tujuan MVP
- Mengimplementasikan UI sesuai desain yang disetujui.
- Menyediakan navigasi lengkap antarlayar utama.
- Menjadikan tiga modul belajar dapat didemokan:
  1. **Sketch Challenge** — anak mengikuti pola gambar.
  2. **Jelajah Cilik** — aktivitas pengenalan objek, bagian tubuh, dan berhitung sederhana.
  3. **Sketch-to-Story** — gambar dipakai sebagai inspirasi cerita anak.
- Menampilkan riwayat aktivitas dan profil.
- Menggunakan data mock pada tahap frontend, tetapi dengan kontrak data/service yang siap diganti.
- Menjaga layout responsif untuk Android portrait dan browser layar lebar.
- Menangani loading, success, empty, error, retry, dan cancel state yang relevan.

### Batasan klaim
Skor tracing adalah umpan balik permainan, bukan diagnosis atau pengukuran klinis perkembangan motorik. Aplikasi tidak boleh mengklaim peningkatan literasi atau motorik yang telah terbukti secara ilmiah hanya dari penggunaan aplikasi.

---

## 2. Status keputusan

Gunakan status berikut dalam dokumentasi dan kode:
- `APPROVED`: telah disepakati.
- `PROPOSED`: usulan yang menunggu persetujuan.
- `TBD`: belum ditetapkan.
- `MOCK`: simulasi untuk pengembangan/demo.
- `DEFERRED`: ditunda dari MVP.
- `VERIFIED`: telah dibuktikan dengan tes/perangkat yang disebutkan.

### Keputusan saat ini
| Area | Status | Keputusan |
|---|---|---|
| Framework aplikasi | APPROVED | Flutter + Dart |
| Target pertama | APPROVED | Android smartphone |
| Target sekunder | APPROVED | Flutter Web untuk browser desktop/Smartboard, setelah pengujian |
| Website publik | APPROVED | Next.js/React terpisah dari aplikasi Flutter jika dibutuhkan |
| Bahasa UI | APPROVED | Bahasa Indonesia |
| Fitur inti | APPROVED | Sketch Challenge, Jelajah Cilik, Sketch-to-Story |
| Backend AI | PROPOSED | Python + FastAPI sebagai perantara ke Gemini |
| Database/auth | PROPOSED | Supabase/PostgreSQL dan Supabase Auth; belum boleh dianggap terhubung sebelum konfigurasi dan tes nyata |
| Computer vision provider | TBD | Jangan mengarang provider atau mengklaim pengenalan AI jika masih mock |
| State management | TBD | Periksa repository; gunakan yang sudah ada. Jika belum ada, pilih solusi sederhana dan konsisten |
| Model/OS Smartboard | TBD | Harus diuji pada perangkat nyata sebelum dinyatakan kompatibel |
| Windows native app | DEFERRED | Prioritaskan browser sebelum desktop native |
| Audio/TTS | DEFERRED | Hanya tampilkan kontrol jika fungsi audio benar-benar tersedia |

---

## 3. Pengguna dan prinsip UX

### Persona
**Anak PAUD/TK (sekitar 4–6 tahun)**
- Belum tentu mampu membaca kalimat panjang.
- Membutuhkan visual, instruksi pendek, dan target sentuh besar.
- Membutuhkan feedback yang positif dan tidak mempermalukan.
- Tidak seharusnya diminta mengisi data pribadi sendiri.

**Guru/orang tua**
- Membantu anak memulai aktivitas.
- Membutuhkan cara sederhana untuk melihat aktivitas dan riwayat.
- Harus memahami kapan gambar diproses oleh layanan eksternal.
- Mengakses pengaturan sensitif melalui area dewasa yang terpisah.

### Prinsip UX
- Ceria, hangat, sederhana, tidak terlalu ramai.
- Pertahankan maskot gajah ungu dan ilustrasi anak sesuai aset yang tersedia.
- Bahasa singkat dan konkret; satu instruksi utama per layar bila memungkinkan.
- Area sentuh besar dengan jarak yang cukup.
- Feedback positif, misalnya “Hebat, kamu sudah mencoba!”.
- Jangan menggunakan leaderboard publik, iklan, atau tekanan kompetitif.
- Jangan mengandalkan warna saja untuk menyampaikan status.
- Animasi harus ringan dan tidak mengganggu.
- Jangan tampilkan angka progres palsu. Jika belum ada data, gunakan empty state atau data demo yang jelas diberi label.
- Jika desain referensi tidak menampilkan status bar perangkat, jangan menggambar status bar palsu di dalam konten aplikasi. Status bar sistem ditangani platform, bukan widget UI.

---

## 4. Design system dan aturan aset

### Gaya visual
- Palet utama: lavender/ungu, putih, pastel kuning, hijau mint, dan warna pendukung yang cocok dengan screenshot final.
- Card membulat, shadow lembut, whitespace cukup, ikon mudah dikenali.
- Gajah ungu adalah maskot konsisten. Jangan mengganti gaya atau menggambar ulang jika aset final sudah tersedia.
- Gunakan aset lokal dari repository bila tersedia. Jangan mengganti aset dengan placeholder internet atau gambar yang tidak memiliki izin.

### Pengelolaan aset
- Periksa folder `assets/` dan deklarasi `pubspec.yaml` sebelum menambah aset.
- Nama file harus deskriptif, misalnya `elephant_login.png`, `onboarding_drawing.png`, `home_sketch_challenge.png`.
- Jangan mengubah transparansi/crop/warna aset yang diberikan kecuali diminta.
- Jika file desain tidak tersedia dalam repository, laporkan aset yang hilang dan minta pengguna menempatkannya; jangan mengarang path.
- Simpan mapping aset di satu tempat jika jumlah aset cukup banyak.

### Komponen reusable yang disarankan
Buat hanya jika pola dipakai berulang:
- `PrimaryButton`
- `SecondaryButton`
- `FeatureCard`
- `AppTextField`
- `PageHeader`
- `ChildFriendlyDialog`
- `LoadingView`
- `EmptyStateView`
- `ErrorStateView`
- `ResponsivePageContainer`
- `BottomNavigation`

Hindari membuat design system besar sebelum dibutuhkan.

---

## 5. Platform dan layout responsif

### Android
- Default portrait untuk onboarding, auth, Home, Riwayat, Profil, dan daftar aktivitas.
- Halaman menggambar boleh menyesuaikan orientasi jika diperlukan, tetapi state gambar tidak boleh hilang diam-diam saat orientasi berubah.
- Uji setidaknya pada emulator dan satu smartphone nyata jika tersedia.

### Flutter Web
- Layout mobile-width tetap dapat dibuka pada browser.
- Pada viewport lebar, gunakan layout desktop/Smartboard yang benar-benar disusun ulang; jangan sekadar meregangkan UI portrait.
- Uji upload file, navigasi browser, refresh, tombol back, dan batasan plugin browser.
- Jangan mengklaim dukungan kamera sebelum diuji. Sediakan pemilihan file sebagai alternatif yang lebih universal.

### Smartboard
- Dianggap target bersyarat sampai merek/model, OS, browser, resolusi, dan kemampuan touch diketahui.
- Target UX: landscape, tombol besar, jarak antarkontrol luas, minim input teks, tidak mengandalkan hover.
- Uji touch multi-point/mouse/stylus sesuai hardware yang tersedia.
- Jika perangkat belum tersedia, status kompatibilitas adalah `NOT VERIFIED`.

### Breakpoint
Jangan mengunci angka breakpoint tanpa memeriksa kode yang ada. Gunakan `LayoutBuilder`/`MediaQuery` atau sistem responsif yang telah dipakai repository. Simpan breakpoint sebagai konstanta terpusat bila diperlukan.

---

## 6. Arsitektur frontend yang siap integrasi

### Prinsip
Gunakan arsitektur berbasis fitur dan pemisahan tanggung jawab. Jangan membuat UI memegang logika data atau AI.

### Alur dependensi
`Screen/Widget → Controller/ViewModel → Use case (bila diperlukan) → Repository/Service interface → Mock atau implementasi nyata`

### Struktur folder contoh
Sesuaikan dengan struktur yang ada; jangan memindahkan semua file jika tidak perlu.

```text
lib/
  main.dart
  app/
    sketchoo_app.dart
    app_router.dart
    app_dependencies.dart
  core/
    theme/
    constants/
    errors/
    widgets/
    responsive/
  features/
    onboarding/
    authentication/
      models/
      repositories/
      services/
      controllers/
      screens/
    home/
    sketch_challenge/
      models/
      repositories/
      services/
      controllers/
      screens/
      widgets/
    jelajah_cilik/
      models/
      repositories/
      services/
      controllers/
      screens/
      widgets/
    sketch_to_story/
      models/
      repositories/
      services/
      controllers/
      screens/
      widgets/
    history/
    profile/
    teacher/
  data/
    mock/
    local/
    remote/
  assets/
test/
docs/
```

### Kontrak service/repository
Gunakan nama dan kontrak yang cocok dengan konvensi repository. Contoh konsep:
- `AuthRepository`: login, register, logout, reset password, session state.
- `LearningSessionRepository`: simpan dan baca sesi belajar.
- `ActivityContentRepository`: mengambil konten aktivitas.
- `ImageRecognitionService`: menganalisis gambar dan menghasilkan objek terstruktur.
- `StoryGenerationService`: membuat cerita dari objek yang dikonfirmasi.
- `ImagePickerService`: memilih gambar dengan adapter platform.
- `ProfileRepository`: membaca/memperbarui profil jika fitur profil benar-benar membutuhkan data persisten.

Setiap interface harus mempunyai implementasi mock untuk tahap frontend dan dapat memiliki implementasi remote nanti. Jangan menambah abstraksi yang tidak memiliki kegunaan nyata.

### Dependency injection
Semua service diberikan dari satu titik konfigurasi/dependency container sederhana. Harus ada cara jelas untuk memilih:
- `development/mock`
- `production/remote`

Jangan mencampur data mock dan produksi dalam satu daftar tanpa indikator. Mode mock harus mudah ditemukan oleh developer dan tidak boleh dianggap autentikasi aman.

---

## 7. Daftar halaman dan perilaku yang diharapkan

### 7.1 Splash Screen
**Tujuan:** memperlihatkan identitas SKETCHOO saat aplikasi dibuka.
- Tampilkan logo/mascot sesuai aset.
- Tidak perlu request backend berat.
- Setelah inisialisasi lokal, arahkan ke onboarding atau halaman auth/home sesuai status onboarding/session yang benar-benar tersedia.
- Jika belum ada persistence, gunakan alur development yang konsisten; jangan mengklaim sesi login tersimpan.

### 7.2 Onboarding 1 — Menggambar
- Ilustrasi anak dan gajah menggambar bersama.
- Headline singkat seperti “Yuk, mulai dengan menggambar!”
- Deskripsi pendek.
- Indikator halaman dan tombol “Lanjut”.
- “Lewati” bila terdapat di desain final.
- Tombol Next mengubah halaman onboarding; bukan sekadar dekorasi.
- Status onboarding dapat disimpan lokal bila mekanisme storage sudah dipilih.

### 7.3 Onboarding 2 — Jelajah
- Ilustrasi gajah menjelajahi objek dengan kaca pembesar.
- Menjelaskan eksplorasi benda, hewan, dan lingkungan.
- Navigasi “Lanjut”, “Kembali”, dan “Lewati” sesuai desain final.

### 7.4 Onboarding 3 — Cerita
- Ilustrasi gajah dengan buku cerita.
- Menjelaskan gambar dapat menjadi inspirasi cerita.
- CTA akhir mengarah ke login/register atau jalur masuk yang disetujui.

### 7.5 Login
- Logo/mascot gajah dan form sesuai screenshot final.
- Field email/nomor HP hanya sesuai metode auth yang benar-benar dipilih; jangan membuat nomor HP berfungsi jika provider tidak mendukungnya.
- Field password dengan show/hide.
- Tombol masuk, link daftar, dan lupa password.
- Validasi input di UI untuk UX; validasi otoritatif dilakukan provider/backend.
- Loading state saat request.
- Error message ramah dan tidak membocorkan apakah suatu email terdaftar.
- Sebelum auth backend tersedia, mock login harus eksplisit berada di development mode dan tidak menyimpan kredensial asli.

### 7.6 Registrasi
- Field nama pendamping jika dibutuhkan, email, password, konfirmasi password.
- Finalisasi field berdasarkan auth provider. Jangan mengumpulkan data anak yang tidak diperlukan.
- Validasi format dan kecocokan password.
- Tombol daftar menjalankan mock flow yang jelas atau integrasi auth nyata.
- Tautan kembali ke login.
- Verifikasi email hanya ditampilkan jika provider dan alurnya sudah dikonfigurasi.

### 7.7 Lupa Password
- Ilustrasi gajah kebingungan/lupa password sesuai aset.
- Input email jika mekanisme reset yang dipilih berbasis email.
- Tombol kirim link hanya benar-benar mengirim ketika provider auth sudah terhubung.
- Mock mode menampilkan simulasi yang jelas dan tidak mengklaim email benar-benar terkirim.
- Tombol kembali ke login.
- Jangan menampilkan password lama atau menyimpan password.

### 7.8 Home/Dashboard anak
Elemen mengikuti referensi:
- Sapaan singkat dan avatar/mascot.
- Kartu ringkas “Petualangan hari ini”.
- Judul ajakan, misalnya “Mau belajar apa hari ini?”.
- Tiga kartu modul:
  1. Sketch Challenge.
  2. Jelajah Cilik.
  3. Sketch-to-Story.
- Ringkasan progres (gambar, cerita, bintang) hanya dari data riil atau data demo yang jelas ditandai.
- Bottom navigation sederhana: **Beranda**, **Riwayat**, **Profil**.
- Jika desain final memiliki notifikasi, jangan menjadikan notifikasi sebagai fitur aktif tanpa fungsi nyata.
- Jangan memasukkan status bar baterai/jam sebagai bagian dari gambar UI.
- Semua kartu dapat ditekan dan membuka halaman terkait.
- Empty state jika belum ada progres; jangan tampilkan angka hard-coded seolah milik pengguna.
- Pada desktop/Smartboard, susun ulang menjadi layout lebar yang nyaman.

### 7.9 Sketch Challenge
**Alur:**
1. Masuk dari kartu Home.
2. Tampilkan instruksi pendek dan daftar pola.
3. Pilih satu pola.
4. Tampilkan canvas dengan template/panduan.
5. Anak menggambar menggunakan touch/mouse/stylus.
6. Tombol Hapus, Periksa, dan Ulang berfungsi.
7. Hasil memberi feedback positif.
8. Simpan sesi melalui repository jika storage tersedia.

**MVP:**
- Sedikitnya 5 pola sederhana jika aset dan waktu memungkinkan.
- Drawing surface mendukung pointer input.
- Reset/undo sesuai desain yang dipilih.
- Scoring adalah `TBD` sampai algoritme ditentukan dan diuji. Jangan menampilkan persentase acak. Jika scoring belum ada, tampilkan status selesai atau feedback tanpa skor numerik.
- Hasil skor bukan diagnosis motorik.

### 7.10 Jelajah Cilik
Sediakan kategori aktivitas sederhana yang disepakati:
- **Pengenalan objek:** misalnya apel, mobil, pohon, kucing.
- **Berhitung:** menghitung benda dalam rentang kecil yang cocok untuk anak TK.
- **Bagian tubuh:** memilih atau mencocokkan bagian tubuh seperti hidung, telinga, mata.

**Perilaku:**
- Instruksi singkat, ilustrasi jelas, area tap besar.
- Feedback benar/salah yang positif.
- Tombol ulangi dan lanjut.
- Konten dapat disimpan sebagai data lokal statis terlebih dahulu.
- Jangan mengklaim computer vision pada aktivitas ini jika hanya memakai jawaban pilihan statis.
- Minimal tiga jenis mini-game masuk MVP bila implementasinya masih realistis; bila scope perlu dipangkas, catat keputusan dan pertahankan dua aktivitas paling stabil.

### 7.11 Sketch-to-Story
**Tujuan:** menggunakan gambar/sketsa sebagai inspirasi fabel ramah anak.

**Alur UI:**
1. Anak/guru memilih atau mengunggah gambar (kamera hanya jika didukung dan diuji).
2. Tampilkan preview dan tombol pilih ulang/batal.
3. Tampilkan objek yang dikenali atau input objek manual jika recognition belum terhubung.
4. Pengguna dapat mengoreksi daftar objek.
5. Pilih tema/moral dari daftar terbatas jika fitur tersedia.
6. Tekan “Jadi Cerita”.
7. Tampilkan loading, hasil cerita, judul, teks, dan moral jika tersedia.
8. Sediakan aksi baca ulang, buat cerita baru, kembali, dan simpan jika fungsi penyimpanan tersedia.

**Pemisahan mode:**
- Mock recognition harus menampilkan data deterministik dan ditandai di developer mode.
- Mock story generation harus diberi label mock/demo; jangan disebut cerita AI live.
- Jika FastAPI/Gemini belum dikonfigurasi, gunakan template fabel lokal atau mock yang aman.
- Jika API gagal, tampilkan retry dan fallback yang jujur.
- Audio/TTS tidak boleh ditampilkan sebagai fungsi aktif jika belum terimplementasi.

### 7.12 Riwayat
- Tab Riwayat menampilkan sesi yang benar-benar dikembalikan repository.
- Item berisi jenis aktivitas, tanggal/waktu, status, dan ringkasan hasil jika tersedia.
- Empty state ketika belum ada data.
- Loading/error state.
- Jangan hard-code riwayat demo tanpa label.
- Detail cerita dapat dibuka jika data model dan route sudah tersedia.

### 7.13 Profil
- Avatar/ilustrasi.
- Nama display yang berasal dari data profile/mock yang jelas.
- Item pengaturan, bantuan, tentang aplikasi, dan keluar hanya jika aksinya ada.
- Kontrol sensitif untuk pendamping harus dibedakan dari mode anak.
- Logout menghapus sesi/token melalui provider ketika auth nyata aktif.
- Jangan membuat halaman admin tersembunyi sebagai satu-satunya perlindungan.

### 7.14 Area guru/pendamping (minimal)
- Ringkasan sesi/aktivitas terbaru bila masuk scope.
- Akses harus dibedakan dari mode anak.
- Pada MVP, cukup ringkasan sederhana; jangan membuat sistem manajemen sekolah penuh.
- Akses data wajib mengikuti otorisasi nyata jika backend aktif.

---

## 8. Navigasi dan routing

### Navigasi utama
Bottom navigation pada mobile:
1. **Beranda**
2. **Riwayat**
3. **Profil**

Modul belajar dibuka dari kartu di Home dan halaman daftar aktivitas. Jangan menambahkan tab yang tidak punya konten.

### Route konseptual
Sesuaikan dengan router yang sudah ada:
- `/splash`
- `/onboarding`
- `/login`
- `/register`
- `/forgot-password`
- `/home`
- `/sketch-challenge`
- `/jelajah-cilik`
- `/sketch-to-story`
- `/history`
- `/profile`
- `/teacher` (jika disetujui)

Jangan membuat route yang tidak digunakan. Back navigation harus berfungsi di Android dan browser. Hindari duplikasi halaman akibat route push berulang yang tidak perlu.

---

## 9. Backend dan database: rancangan untuk integrasi mendatang

**Status: belum terhubung kecuali repository menunjukkan bukti sebaliknya.** Jangan mengubah status menjadi integrated hanya karena interface sudah dibuat.

### Arsitektur target yang diusulkan
- Flutter client: UI dan interaksi.
- Supabase Auth/PostgreSQL/Storage: autentikasi, data akun pendamping, profil minimal, sesi belajar, dan metadata cerita jika pilihan ini disetujui.
- FastAPI: endpoint backend untuk alur AI dan validasi request.
- Gemini API: generasi cerita melalui FastAPI, bukan dipanggil langsung dari Flutter.
- Image recognition: provider belum ditentukan; buat interface terlebih dahulu.

### Aturan integrasi
- Flutter tidak boleh menyimpan Gemini API key atau Supabase service-role key.
- Gunakan environment variables di backend, misalnya `GEMINI_API_KEY`, dan jangan commit `.env`.
- Konfigurasi URL backend melalui environment/config, bukan string tersebar.
- Supabase client hanya boleh menggunakan credential publik yang memang dirancang untuk client; aktifkan RLS dan kebijakan akses yang tepat. Service-role key hanya server-side.
- Jangan membuat tabel atau endpoint produksi sebelum skema/kontrak disetujui.
- Semua respons remote divalidasi dan dipetakan ke model domain.
- Tambahkan timeout, retry terbatas, dan error mapping.
- Jangan mengirim nama lengkap, foto wajah, alamat, atau data sensitif anak ke model AI.
- Sebelum gambar dikirim ke layanan eksternal, UI harus memberi indikasi yang jelas kepada pendamping dan kebijakan privasi harus ditetapkan.

### Kontrak konseptual FastAPI
Endpoint yang pernah direncanakan: `POST /generate-story`. Statusnya **TBD/PROPOSED sampai benar-benar ditemukan di backend**.
- Jangan mengarang bentuk request/response final.
- Baca dokumentasi backend aktual atau kode OpenAPI sebelum menghubungkan client.
- Buat DTO/model yang mengikuti kontrak backend nyata.
- Jika endpoint belum tersedia, `MockStoryGenerationService` tetap digunakan.

### Mode aplikasi
Sediakan konfigurasi yang jelas, misalnya `mock` dan `remote`. Jangan membuat mode produksi aktif secara default jika endpoint/credential belum tersedia. Mock harus bisa diuji tanpa internet.

---

## 10. Model data konseptual

Model ini usulan, bukan skema database final. Implementasikan hanya yang dibutuhkan.

### `LearningSession`
- `id`
- `activityType` (`sketch_challenge`, `jelajah_cilik`, `sketch_to_story`)
- `activityId` jika relevan
- `startedAt`
- `completedAt` nullable
- `status` (`completed`, `cancelled`, `incomplete`)
- `resultSummary` nullable
- `score` nullable, hanya jika scoring nyata tersedia
- `sourceMode` (`mock`, `local`, `remote`) untuk transparansi/debug jika diperlukan

### `InteractiveStory`
- `id`
- `title`
- `body`
- `moral` nullable
- `confirmedObjects`
- `createdAt`
- `generationMode` (`mock`, `template`, `remote`)
- `imageReference` nullable, hanya jika kebijakan penyimpanan gambar disetujui

### `ActivityContent`
- `id`
- `title`
- `instruction`
- `assetPath`
- `activityType`
- `items`
- `difficulty`
- `feedbackConfig`

### Aturan data
- Gunakan ID stabil.
- Validasi data dari API/storage.
- Jangan simpan gambar permanen secara default.
- Hindari duplikasi sesi akibat retry.
- Jangan menyimpan password plaintext.
- Kebijakan retensi dan penghapusan data anak masih `TBD`.

---

## 11. State management dan pola async

- Periksa state management yang sudah ada sebelum memilih package.
- Semua operasi async harus memiliki state yang jelas: `idle`, `loading`, `success`, `empty` bila relevan, `error`, dan `cancelled`.
- Disable aksi berulang saat request berlangsung.
- Berikan retry hanya untuk error yang dapat dicoba ulang.
- Error teknis diterjemahkan menjadi pesan pengguna yang aman.
- Jangan menampilkan stack trace atau response mentah backend di UI.
- Jangan mengubah UI menjadi sukses sebelum repository/service mengonfirmasi hasil.
- Hindari setState setelah widget disposed; batalkan subscription/request jika diperlukan.
- UI harus dapat diuji dengan mock repository.

---

## 12. Keamanan, privasi, dan keselamatan anak

- Minimisasi data: kumpulkan hanya yang diperlukan.
- Jangan meminta alamat rumah, lokasi, nomor telepon anak, tanggal lahir lengkap, atau foto wajah.
- Jangan memakai data anak untuk melatih model.
- Jangan log gambar, password, token, atau informasi identitas.
- Foto gambar dapat memuat informasi pribadi tidak sengaja; jelaskan pemrosesan eksternal sebelum upload.
- Jangan memasang iklan atau tracking anak secara default.
- Semua fitur akun dan data yang dilindungi harus memakai otorisasi provider/backend, bukan sekadar menyembunyikan tombol.
- RLS harus dirancang dan diuji sebelum memakai Supabase untuk data pengguna.
- Kebijakan privasi, persetujuan orang tua/guru, retensi, penghapusan, dan provider eksternal harus ditinjau sebelum produksi.
- Cerita harus ramah anak, tidak menakutkan, tidak diskriminatif, tidak seksual, dan tidak memuat instruksi berbahaya.
- Sediakan fallback aman jika AI menghasilkan output kosong/tidak valid/tidak sesuai.

---

## 13. Error, empty, loading, dan fallback states

Setiap halaman harus memiliki state yang relevan:
- Loading saat mengambil data atau menunggu proses.
- Empty state jika belum ada data.
- Error state dengan pesan jelas dan tombol coba lagi bila masuk akal.
- Cancel state saat pengguna membatalkan file picker atau aktivitas.
- Offline/unavailable state saat backend tidak tersedia.
- Permission denied untuk fitur perangkat yang membutuhkan izin.
- Fallback template/manual untuk fitur AI yang belum tersedia.

Jangan menampilkan loading tanpa batas. Jangan menampilkan sukses jika penyimpanan atau request gagal. Mock mode harus bisa dikenali developer dan tidak boleh menyamar sebagai layanan produksi.

---

## 14. Kriteria penerimaan

### UI dan navigasi
- Semua halaman yang disetujui dapat dibuka dan ditutup melalui alur navigasi yang benar.
- Tombol utama tidak inert.
- Desain dibandingkan dengan screenshot/Figma pada ukuran viewport yang sama.
- Tidak ada overflow kritis pada viewport target yang diuji.
- Aset memakai file yang tersedia dan sesuai.
- Tidak ada status bar perangkat yang digambar ke dalam halaman bila desain tidak memintanya.

### Auth (mock sampai provider tersedia)
- Validasi form bekerja.
- Show/hide password bekerja.
- Login/register/reset menampilkan hasil mock yang jujur atau menggunakan provider nyata yang terkonfigurasi.
- Tidak ada password/token dalam log.
- Tidak mengklaim email reset terkirim jika tidak ada provider nyata.

### Sketch Challenge
- Pola dapat dipilih.
- Canvas menerima input touch/mouse yang didukung.
- Hapus/ulang berfungsi.
- Hasil/feedback konsisten.
- Scoring tidak palsu; jika algoritme belum ditentukan, tidak ada persentase acak.
- Aktivitas dapat dibatalkan tanpa crash.

### Jelajah Cilik
- Aktivitas statis dapat dibuka.
- Jawaban benar/salah diproses sesuai konten.
- Feedback positif dan kontrol ulang/lanjut berfungsi.
- Konten dapat diulang.
- Aset/data invalid ditangani tanpa crash.

### Sketch-to-Story
- Pemilihan gambar, preview, cancel, dan pilih ulang berfungsi pada platform yang diuji.
- Objek dapat dipilih/dikoreksi secara manual bila recognition belum tersedia.
- Mode mock/template ditandai jelas.
- Respons cerita divalidasi sebelum ditampilkan.
- Error AI menghasilkan retry/fallback, bukan crash.
- Tidak ada secret di Flutter.

### Riwayat/Profil
- Data ditampilkan dari repository, bukan angka palsu.
- Empty/error state tersedia.
- Keluar berfungsi sesuai mode auth yang aktif.
- Tidak ada data pengguna lain yang bocor.

### Engineering
- Formatter dijalankan.
- `flutter analyze` dijalankan.
- Test relevan dijalankan.
- README setup diperbarui jika diperlukan.
- Status platform dan integrasi dilaporkan berdasarkan bukti.
- Tidak ada dependency, file, endpoint, atau fitur fiktif.

---

## 15. Strategi testing

### Unit tests
- Form validation.
- Mapping error.
- Model parsing/validation.
- Logic jawaban mini-game.
- Logic scoring jika sudah ditetapkan.
- Story output validation dan fallback.
- Repository mock.

### Widget tests
- Splash/onboarding navigation.
- Login/register/forgot password interactions.
- Home cards dan bottom navigation.
- Sketch Challenge controls.
- Jelajah Cilik answer feedback.
- Sketch-to-Story states.
- Riwayat empty/list/error state.
- Profile/logout.
- Responsivitas dasar dan overflow.

### Integration/manual tests
- Alur splash → onboarding → login/mock → Home.
- Home → setiap modul → kembali ke Home.
- Aktivitas selesai → riwayat (jika penyimpanan aktif).
- Browser refresh/back dan upload gambar pada Flutter Web.
- Touch/mouse/stylus sesuai perangkat.
- Android emulator dan perangkat nyata bila tersedia.
- Smartboard hanya dinyatakan verified setelah diuji di perangkat yang disebutkan.

### Perintah quality gate
Jalankan dari root Flutter project sesuai kondisi repository:
```bash
dart format .
flutter analyze
flutter test
```
Jalankan build spesifik platform hanya jika SDK dan dependency tersedia, misalnya:
```bash
flutter build apk --debug
flutter build web
```
Jika perintah gagal, catat output/error relevan. Jangan memperbaiki error dengan perubahan besar yang tidak terkait tanpa persetujuan.

---

## 16. Roadmap implementasi

Urutan disesuaikan dengan keadaan repository; jangan menganggap minggu sebelumnya telah selesai.

### Milestone A — Audit dan baseline
- Periksa project, assets, dependencies, router, state management.
- Jalankan app dan tes awal.
- Catat perbedaan antara desain dan implementasi.
- Buat daftar screen/route yang ada.

### Milestone B — UI shell dan design system
- Tema, typography, spacing, reusable components.
- Router dan responsive page container.
- Splash, onboarding, login, register, forgot password.
- Semua data/auth masih mock yang diberi label jelas.

### Milestone C — Home dan navigasi
- Home dashboard sesuai desain.
- Bottom nav Beranda/Riwayat/Profil.
- Empty/progress state tidak menggunakan angka palsu.
- Responsive layout mobile dan layar lebar.

### Milestone D — Aktivitas belajar
- Sketch Challenge drawing surface, pattern selection, reset, feedback.
- Jelajah Cilik dengan konten statis dan validasi jawaban.
- Simpan sesi ke mock/local repository.

### Milestone E — Sketch-to-Story
- Image picker adapter dan preview.
- Manual object selection/mock recognition.
- Mock/template story generation dengan status jelas.
- UI error/loading/retry/fallback.
- Jangan integrasikan Gemini sampai kontrak FastAPI tersedia dan disetujui.

### Milestone F — Data/backend integration
- Validasi kontrak API nyata.
- Implementasi remote repository/service tanpa mengubah UI.
- Auth/database hanya setelah provider dan skema disetujui.
- Uji keamanan dan error path.

### Milestone G — QA dan demo
- Perbandingan screenshot.
- Analyzer/tests.
- Android test.
- Flutter Web test.
- Smartboard test jika hardware tersedia.
- Dokumentasikan fitur mock/TBD dan keterbatasan.

---

## 17. Instruksi kerja khusus untuk Cursor

### Saat memulai sesi
1. Baca `PRD.md` dan `docs/DECISIONS.md` jika ada.
2. Periksa `git status`; jangan menimpa perubahan pengguna.
3. Periksa file yang relevan dan cari implementasi yang sudah ada.
4. Tulis rencana singkat sebelum perubahan yang lebih dari satu file.
5. Jika permintaan ambigu, tanyakan satu pertanyaan penting atau tandai asumsi sebagai `TBD`.

### Saat mengerjakan UI dari screenshot
1. Identifikasi viewport/aspect ratio referensi.
2. Periksa apakah aset ilustrasi tersedia di repository.
3. Pecah UI menjadi komponen reusable hanya jika berguna.
4. Implementasikan layout dan spacing sedekat mungkin dengan referensi.
5. Sambungkan interaksi lokal (navigasi, validasi, state) tanpa membuat integrasi backend palsu.
6. Ambil screenshot hasil jika lingkungan memungkinkan dan bandingkan.
7. Catat bagian yang belum presisi atau aset yang hilang.

### Saat diminta integrasi backend di kemudian hari
1. Periksa kontrak endpoint/API aktual terlebih dahulu.
2. Pastikan environment variables dan secret disimpan di tempat yang benar.
3. Implementasikan adapter remote yang memenuhi interface yang sudah dipakai UI.
4. Pertahankan mock implementation untuk unit/widget tests.
5. Tambahkan timeout, error mapping, dan test.
6. Jangan mengubah layout hanya karena data sekarang datang dari API.
7. Jangan menganggap endpoint `/generate-story` ada sebelum memverifikasi backend.

### Jangan lakukan
- Jangan menulis ulang seluruh app demi satu halaman.
- Jangan menambah state management package tanpa audit.
- Jangan mengubah desain secara kreatif tanpa diminta.
- Jangan mengklaim AI live jika masih mock.
- Jangan memasukkan API key ke Flutter.
- Jangan menambah fitur admin/CMS/analytics yang tidak diminta.
- Jangan menyatakan Smartboard kompatibel tanpa uji nyata.
- Jangan menghapus file atau dependency yang belum dipahami.

---

## 18. Format laporan setiap task

```text
Task:
Tujuan:
File diubah:
Perilaku yang sudah berfungsi:
Mock/TBD:
Tes yang dijalankan:
Hasil tes:
Belum selesai:
Risiko/keputusan yang dibutuhkan:
Langkah berikutnya:
```

---

## 19. Prioritas MVP

Jika waktu terbatas, prioritaskan dalam urutan:
1. App shell dan navigasi stabil.
2. UI onboarding/auth/Home sesuai desain.
3. Sketch Challenge yang benar-benar bisa dipakai.
4. Jelajah Cilik dengan aktivitas statis yang benar-benar berfungsi.
5. Sketch-to-Story dengan mock/template yang jujur dan jalur integrasi siap.
6. Riwayat dan profil berdasarkan data yang benar-benar ada.
7. Backend/auth/AI nyata setelah kontrak dan credential tersedia.
8. Polishing lintas platform dan pengujian Smartboard.

**Prinsip final:** lebih baik sedikit fitur yang benar-benar bekerja daripada banyak tombol yang hanya terlihat bagus. UI boleh selesai lebih dahulu, tetapi batas antara mock dan produksi harus selalu jelas.
