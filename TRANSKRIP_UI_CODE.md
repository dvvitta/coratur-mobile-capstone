# TRANSKRIP DETAIL KODE UI (SPLASH ➔ ONBOARDING ➔ AUTH ➔ HOME)
Dokumentasi teknis mendalam mengenai:
1. **Asal-usul path aset gambar** (lokasi definisi dan baris pemanggilannya).
2. **Manajemen layout** (`Row`, `Column`, `Stack`, `Expanded`, `Flexible`, `Align`, `Spacer`, `Positioned`).
3. **Fungsi spesifik setiap baris/blok kode UI** dan alasan teknis pemilihannya.

---

## 0. PUSAT DEFINISI PATH GAMBAR (`AssetPaths`)
**File:** `lib/core/constants/asset_paths.dart`

Semua path gambar dikumpulkan di class `AssetPaths` sebagai konstanta murni (`static const`) agar terhindar dari typo penulisan string di berbagai file UI:
```dart
abstract final class AssetPaths {
  // 1. Splash
  static const logo = 'assets/images/logo.png';
  static const splashFullscreen3 = 'assets/background/full screen splash 3.png';

  // 2. Onboarding
  static const onboardIllustration1 = 'assets/background/onboardd 1.png';
  static const onboardIllustration2 = 'assets/background/onboardd 2.png';
  static const onboardIllustration3 = 'assets/background/onboardd 3.png';

  // 3. Auth
  static const authElephant = 'assets/images/gajah login regris.png';
  static const authBackground = 'assets/background/bg login regris.png';

  // 4. Home
  static const userAvatar = 'assets/images/avatar.png';
  static const palette = 'assets/images/palette.png';
  static const sketchChallenge = 'assets/images/sketch challenge.png';
  static const jelajahCilik = 'assets/images/jelajah cilik.png';
  static const sketchToStory = 'assets/images/sketch-to-story.png';
}
```

---

## 1. SPLASH SCREEN
**File Sumber:** `lib/features/splash/screens/splash_screen.dart`

### A. Lokasi Pemanggilan Path Gambar di Kode
Gambar dimuat pada dua titik:
1. **Pre-cache aset ke memori GPU (Baris 78–81):**
   ```dart
   await Future.wait<void>([
     precacheImage(const AssetImage(AssetPaths.logo), context),
     precacheImage(const AssetImage(AssetPaths.splashFullscreen3), context),
   ]);
   ```
   *Tujuan:* Mencegah GPU me-render frame kosong atau kedipan putih saat animasi pertama kali dimulai.
2. **Render Background Layar Penuh (Baris 171–177):**
   ```dart
   Image.asset(
     AssetPaths.splashFullscreen3,
     key: const Key('splash_background'),
     fit: BoxFit.cover,
     alignment: Alignment.center,
     gaplessPlayback: true,
   )
   ```
   *Tujuan:* Mengambil `'assets/background/full screen splash 3.png'`, memotongnya secara proporsional (`BoxFit.cover`) agar memenuhi resolusi HP apapun tanpa tepi hitam.
3. **Render Logo Utama (Baris 192–199):**
   ```dart
   Image.asset(
     AssetPaths.logo,
     key: const Key('splash_logo'),
     width: logoWidth,
     height: logoHeight,
     fit: BoxFit.contain,
     filterQuality: FilterQuality.high,
   )
   ```
   *Tujuan:* Mengambil `'assets/images/logo.png'`, mempertahankan rasio aslinya (`BoxFit.contain`).

### B. Bedah Layout: Kenapa Pakai `Stack` & Bukan `Column`?
Pada Splash Screen, logo dan background **harus bertumpuk** dan bergerak secara independen berdasarkan waktu, bukan berurutan secara vertikal.

```dart
// Baris 164 - 209
return Stack(
  fit: StackFit.expand, // Memaksa anak Stack memenuhi seluruh layar (fullscreen)
  children: [
    // LAPIS 1: Kanvas dasar putih
    const ColoredBox(color: Colors.white),

    // LAPIS 2: Background yang memudar masuk (fade-in)
    IgnorePointer(
      child: Opacity(
        opacity: backgroundOpacity.clamp(0.0, 1.0),
        child: Image.asset(AssetPaths.splashFullscreen3, fit: BoxFit.cover),
      ),
    ),

    // LAPIS 3: Logo yang naik ke atas
    Positioned(
      top: logoTop,       // Posisi Y dihitung dinamis (naik dari 50% ke 22%)
      left: 0,
      right: 0,          // left: 0 & right: 0 otomatis memusatkan secara horizontal
      height: logoHeight,
      child: IgnorePointer(
        child: Opacity(
          opacity: logoOpacity.clamp(0.0, 1.0),
          child: Image.asset(AssetPaths.logo, fit: BoxFit.contain),
        ),
      ),
    ),
  ],
);
```

#### Alasan Parameter Layout:
* **`LayoutBuilder` (Baris 149):** Mengambil `constraints.maxWidth` dan `constraints.maxHeight` untuk menghitung rasio logo:
  ```dart
  final logoWidth = (width * 0.78).clamp(168.0, 360.0);
  final logoHeight = logoWidth * (1024 / 1536); // Rasio aspek asli logo (1024 : 1536)
  ```
* **Kalkulasi Posisi Bergerak (Baris 155–159):**
  * Logo mulai di titik tengah layar: `startCenterY = height * 0.50`.
  * Logo berakhir di posisi atas: `endCenterY = height * 0.22`.
  * `logoCenterY = startCenterY + (endCenterY - startCenterY) * logoMove`: rumus interpolasi posisi Y berbasis nilai animasi `0.0 ➔ 1.0`.

---

## 2. ONBOARDING SCREEN
**File Sumber:**
* `lib/features/onboarding/screens/onboarding_screen.dart`
* `lib/features/onboarding/models/onboarding_page_data.dart`
* `lib/features/onboarding/widgets/onboarding_page_content.dart`

### A. Lokasi Pemanggilan Path Gambar di Kode
1. **Didaftarkan di Model Data (`onboarding_page_data.dart`, Baris 18–33):**
   ```dart
   static const pages = [
     OnboardingPageData(
       illustrationPath: AssetPaths.onboardIllustration1, // 'assets/background/onboardd 1.png'
       title: 'Yuk, Mulai dengan\nmenggambar!',
       body: 'Tunjukkan kreatifitasmu...',
     ),
     OnboardingPageData(
       illustrationPath: AssetPaths.onboardIllustration2, // 'assets/background/onboardd 2.png'
       title: 'Jelajahi dunia\npenuh pengetahuan!',
       body: 'ikuti berbagai aktivitas...',
     ),
     OnboardingPageData(
       illustrationPath: AssetPaths.onboardIllustration3, // 'assets/background/onboardd 3.png'
       title: 'Gambar jadi cerita,\ncerita jadi petualangan!',
       body: 'Setiap coretanmu...',
     ),
   ];
   ```
2. **Dirender di Komponen Halaman (`onboarding_page_content.dart`, Baris 30–40):**
   ```dart
   Image.asset(
     page.illustrationPath, // Diambil dinamis dari data halaman aktif
     fit: BoxFit.contain,
     filterQuality: FilterQuality.high,
   )
   ```

### B. Bedah Layout: Struktur `Column`, `Row`, `Flexible`, & `Spacer`
Tampilan Onboarding disusun vertikal murni dari atas ke bawah menggunakan `Column`:

```dart
// onboarding_screen.dart Baris 92 - 170
Column(
  children: [
    // 1. BARIS ATAS: Tombol "Lewati" dirapatkan ke pojok kanan
    Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _onSkip,
        child: const Text('Lewati'),
      ),
    ),

    // 2. AREA TENGAH ELASTIS: PageView Ilustrasi Gambar
    Flexible(
      flex: 5, // Mengalokasikan 5 porsi ruang kosong untuk gambar ilustrasi
      child: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) => OnboardingPageContent(page: pages[index]),
      ),
    ),

    const SizedBox(height: 4),

    // 3. TEKS JUDUL & BODY
    Text(pages[_index].title, textAlign: TextAlign.center, ...),
    const SizedBox(height: 10),
    Text(pages[_index].body, textAlign: TextAlign.center, ...),

    const SizedBox(height: 16),

    // 4. INDIKATOR TITIK (ROW HORIZONTAL)
    _PageDots(count: pages.length, currentIndex: _index),

    const SizedBox(height: 16),

    // 5. TOMBOL AKSI UTAMA "LANJUT"
    SizedBox(
      width: double.infinity, // Memaksa tombol selebar layar (full width)
      height: 56,             // Tinggi tombol jempol ergonomis
      child: FilledButton(
        onPressed: _onLanjut,
        child: const Text('Lanjut'),
      ),
    ),

    // 6. BUFFER BAWAH ELASTIS
    const Spacer(flex: 1), // Mengalokasikan 1 porsi ruang kosong di bawah tombol
  ],
)
```

#### Detail Penataan Baris pada Titik Indikator (`_PageDots` - Baris 189–216):
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center, // Memusatkan titik-titik tepat di tengah layar
  children: List.generate(count, (index) {
    final isCurrent = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isCurrent ? 24 : 8, // Titik aktif melebar jadi 24 px; nonaktif bulat 8 px
      height: 8,
      decoration: BoxDecoration(
        color: isCurrent ? OnboardingColors.accent : OnboardingColors.dotInactive,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }),
)
```

#### Detail Tumpukan Lingkaran Cahaya (`OnboardingPageContent` - Baris 13–42):
```dart
Stack(
  alignment: Alignment.center, // Memusatkan gambar tepat di atas lingkaran pendar
  children: [
    // Lapisan bawah: Lingkaran gradient pendar ungu muda
    Container(
      width: 260,
      height: 260,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [OnboardingColors.glow, Color(0x00FFFFFF)],
        ),
      ),
    ),
    // Lapisan atas: Gambar ilustrasi
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Image.asset(page.illustrationPath, fit: BoxFit.contain),
    ),
  ],
)
```

---

## 3. AUTHENTICATION SCREEN (LOGIN & REGISTER)
**File Sumber:**
* `lib/features/authentication/screens/auth_screen.dart`
* `lib/features/authentication/widgets/auth_form_sheet.dart`
* `lib/features/authentication/widgets/auth_tabs.dart`

### A. Lokasi Pemanggilan Path Gambar di Kode
1. **Background Layar Penuh (`auth_screen.dart`, Baris 214–218):**
   ```dart
   Image.asset(
     AssetPaths.authBackground, // 'assets/background/bg login regris.png'
     fit: BoxFit.cover,
     alignment: Alignment.topCenter,
   )
   ```
   *Fungsi:* Mengunci gambar pemandangan di seluruh latar belakang. `alignment: Alignment.topCenter` menjaga langit dan bukit atas tetap stabil terlihat.
2. **Karakter Gajah Melayang (`auth_form_sheet.dart`, Baris 343–349):**
   ```dart
   Positioned(
     top: elephantTop, // Koordinat dihitung dinamis agar kaki gajah mendarat di kartu
     left: 0,
     right: 0,
     child: IgnorePointer(
       child: Center(
         child: Image.asset(
           AssetPaths.authElephant, // 'assets/images/gajah login regris.png'
           width: elephantWidth,
           height: elephantHeight,
           fit: BoxFit.contain,
         ),
       ),
     ),
   )
   ```

### B. Bedah Layout: Penanganan Keyboard & Struktur Bertingkat
#### 1. Lapisan Utama Layar (`auth_screen.dart`, Baris 211–345)
Menggunakan `Stack(fit: StackFit.expand)` 3 Lapis:
* **Lapis 1 (Paling Belakang):** `Image.asset(AssetPaths.authBackground)` (Statis).
* **Lapis 2 (Tengah):** Form Card yang bergerak saat keyboard muncul via `TweenAnimationBuilder` & `Transform.translate`:
  ```dart
  TweenAnimationBuilder<double>(
    tween: Tween(
      begin: 0,
      end: -((MediaQuery.viewInsetsOf(context).bottom * 0.45).clamp(0.0, 150.0)),
    ),
    duration: const Duration(milliseconds: 180),
    curve: Curves.easeOutCubic,
    builder: (context, offsetY, child) => Transform.translate(
      offset: Offset(0, offsetY), // Geser ke atas sebesar offsetY
      child: child,
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: Breakpoints.compact),
      child: Column(
        children: [
          const SafeArea(bottom: false, child: SizedBox(height: 50)), // Ruang kepala di atas
          Expanded(child: AuthFormSheet(...)),                        // Sheet form mengisi sisa layar
        ],
      ),
    ),
  )
  ```
  *Kenapa `Expanded`?* Agar `AuthFormSheet` mengisi sisa tinggi layar secara penuh dari batas bawah `SizedBox(height: 50)` sampai dasar layar HP.
* **Lapis 3 (Paling Depan):** Tombol Kembali Melayang (`auth_back`):
  ```dart
  Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(...), // Lingkaran tombol back
      ),
    ),
  )
  ```

#### 2. Penataan Baris & Kolom di Formulir (`auth_form_sheet.dart`)
Semua elemen formulir diatur dalam `Column(crossAxisAlignment: CrossAxisAlignment.stretch)` di dalam `AuthScrollView`:

1. **Tab Masuk / Daftar (`auth_tabs.dart`, Baris 30–48):**
   ```dart
   DecoratedBox(
     decoration: BoxDecoration(color: AuthColors.tabTrack, borderRadius: BorderRadius.circular(14)),
     child: Row(
       children: [
         // Expanded membuat tab 'Masuk' mengambil tepat 50% lebar
         Expanded(child: _TabChip(label: 'Masuk', selected: tab == AuthTab.login, ...)),
         // Expanded membuat tab 'Daftar' mengambil tepat 50% lebar
         Expanded(child: _TabChip(label: 'Daftar', selected: tab == AuthTab.register, ...)),
       ],
     ),
   )
   ```
2. **Baris "Ingat Saya" & "Lupa Sandi?" (`auth_form_sheet.dart`, Baris 214–260):**
   ```dart
   Row(
     children: [
       SizedBox(width: 24, height: 24, child: Checkbox(...)), // Kotak centang ukuran tetap
       const SizedBox(width: 8),
       // Expanded mengisi ruang kosong di tengah:
       const Expanded(
         child: Text('Ingat saya', style: TextStyle(fontSize: 14)),
       ),
       // TextButton otomatis terdorong ke paling kanan layar oleh Expanded:
       TextButton(
         onPressed: onForgotPassword,
         child: const Text('Lupa Sandi?'),
       ),
     ],
   )
   ```
3. **Baris Pemisah "Atau" (`auth_form_sheet.dart`, Baris 271–295):**
   ```dart
   Row(
     children: [
       // Expanded kiri: Garis tipis mengisi sisa ruang sebelah kiri
       Expanded(child: Divider(color: AuthColors.fieldBorder)),
       // Padding tengah: Teks 'Atau'
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Text('Atau', style: TextStyle(color: AuthColors.muted)),
       ),
       // Expanded kanan: Garis tipis mengisi sisa ruang sebelah kanan dengan panjang yang persis sama
       Expanded(child: Divider(color: AuthColors.fieldBorder)),
     ],
   )
   ```
4. **Tombol "Continue with Google" (`auth_form_sheet.dart`, Baris 316–334):**
   ```dart
   Row(
     mainAxisAlignment: MainAxisAlignment.center, // Memusatkan logo + teks di tengah tombol
     mainAxisSize: MainAxisSize.min,              // Tidak rakus mengambil lebar berlebihan
     children: [
       const GoogleLogo(),                         // CustomPainter logo Google 4 warna
       const SizedBox(width: 8),
       Flexible(                                   // Mencegah teks meluap (overflow) pada layar sempit
         child: Text(
           'Continue with Google',
           maxLines: 1,
           overflow: TextOverflow.ellipsis,
         ),
       ),
     ],
   )
   ```

---

## 4. MAIN NAVIGATION SHELL & HOME SCREEN
**File Sumber:**
* `lib/features/main/screens/main_navigation_shell.dart`
* `lib/core/widgets/curator_bottom_nav.dart`
* `lib/features/home/screens/home_screen.dart`

### A. Lokasi Pemanggilan Path Gambar di Kode
Semua ikon ilustrasi di Home Screen diambil dari `AssetPaths`:
1. **Avatar Pengguna (`home_screen.dart`, Baris 136–147):**
   ```dart
   Image.asset(
     AssetPaths.userAvatar, // 'assets/images/avatar.png'
     fit: BoxFit.cover,
   )
   ```
2. **Ikon Palet Petualangan (`home_screen.dart`, Baris 212–222):**
   ```dart
   Image.asset(
     AssetPaths.palette, // 'assets/images/palette.png'
     width: 86,
     height: 86,
     fit: BoxFit.contain,
   )
   ```
3. **Kartu Belajar Sketch Challenge & Jelajah Cilik (`home_screen.dart`, Baris 275 & 288):**
   ```dart
   imagePath: AssetPaths.sketchChallenge, // 'assets/images/sketch challenge.png'
   imagePath: AssetPaths.jelajahCilik,    // 'assets/images/jelajah cilik.png'
   ```
4. **Banner Sketch-to-Story (`home_screen.dart`, Baris 318–326):**
   ```dart
   Image.asset(
     AssetPaths.sketchToStory, // 'assets/images/sketch-to-story.png'
     fit: BoxFit.contain,
   )
   ```

### B. Bedah Layout: Kapsul Navigasi Bawah (`CuratorBottomNav`)
**File:** `lib/core/widgets/curator_bottom_nav.dart`

Menggunakan kombinasi `LayoutBuilder`, `Stack`, dan `Row`:
```dart
// curator_bottom_nav.dart Baris 31 - 105
LayoutBuilder(
  builder: (context, constraints) {
    final totalWidth = constraints.maxWidth;
    const tabCount = 3;
    final slotWidth = totalWidth / tabCount; // Membagi lebar nav bar jadi 3 slot rata
    const pillWidth = 74.0;
    const pillHeight = 44.0;

    // Menghitung posisi horizontal X agar kapsul ungu berada di tengah slot tab aktif:
    final targetLeft = (slotWidth * selectedIndex) + ((slotWidth - pillWidth) / 2);

    return SizedBox(
      height: pillHeight,
      child: Stack(
        children: [
          // 1. LAPISAN BELAKANG: Kapsul ungu yang meluncur smooth
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            left: targetLeft, // Bergeser secara horizontal mengikuti targetLeft
            top: 0,
            width: pillWidth,
            height: pillHeight,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6D3FE0),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),

          // 2. LAPISAN DEPAN: 3 Item Tab yang dapat ditekan
          Row(
            children: [
              Expanded(child: _buildItem(context, 0, Icons.home_rounded, 'Home')),
              Expanded(child: _buildItem(context, 1, Icons.history_rounded, 'History')),
              Expanded(child: _buildItem(context, 2, Icons.person_rounded, 'Profile')),
            ],
          ),
        ],
      ),
    );
  },
)
```
*Kenapa `Row` memakai 3 buah `Expanded`?* Masing-masing tab dijamin mendapat lebar tepat 1/3 dari layar secara proporsional di HP ukuran berapapun.

Di dalam setiap item nav (`_buildItem`, Baris 108–137):
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center, // Memusatkan ikon dan label di dalam slot
  children: [
    Icon(icon, size: 20, color: color),
    if (isSelected) ...[ // Teks label hanya dimunculkan jika tab sedang dipilih
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    ],
  ],
)
```

---

### C. Bedah Layout: Komponen Beranda (`HomeScreen`)
Struktur keseluruhan adalah `Column`:
* Bagian atas: `_buildStickyHeader()` (tetap menempel di atas).
* Bagian bawah: `Expanded` ➔ `ListView` (konten yang dapat di-scroll).

#### 1. Header Pengguna Lengket (`_buildStickyHeader`, Baris 121–195):
```dart
Row(
  children: [
    // Foto Avatar (kiri)
    Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(child: Image.asset(AssetPaths.userAvatar)),
    ),
    const SizedBox(width: 12),

    // Expanded di tengah: Menyerap seluruh ruang sisa untuk teks salam
    Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Halo, ${widget.userName}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(width: 4),
          const Text('✨', style: TextStyle(fontSize: 18)),
        ],
      ),
    ),

    // Tombol Notifikasi Lingkaran (kanan)
    Material(
      shape: const CircleBorder(),
      child: InkWell(child: const Icon(Icons.notifications_outlined)),
    ),
  ],
)
```
*Kenapa `Expanded` pada teks salam?* Jika nama user sangat panjang (misal: "Halo, Muhammad Syarifuddin!"), teks tidak akan menabrak atau menendang tombol notifikasi keluar layar.

#### 2. Kartu Petualangan Hari Ini (`_buildAdventureCard`, Baris 197–253):
```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // Gambar palet cat di sisi kiri
    Image.asset(AssetPaths.palette, width: 86, height: 86),
    const SizedBox(width: 18),

    // Expanded di sisi kanan membungkus Column teks
    const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Petualangan Hari ini', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          SizedBox(height: 6),
          Text('Kamu sudah menyelesaikan\n3 permainan hari ini', style: TextStyle(fontSize: 14)),
        ],
      ),
    ),
  ],
)
```
*Kenapa `Expanded(child: Column(...))`?* Kolom teks mengetahui batas lebar maksimumnya sehingga kalimat otomatis terpotong ke baris baru (*word-wrap*) dan terhindar dari *render overflow strip kuning-hitam*.

#### 3. Kartu Belajar Berpasangan (`_buildLearningCards`, Baris 266–296):
```dart
Row(
  children: [
    // Kartu Kiri: Sketch Challenge (50% lebar layar minus jarak)
    Expanded(
      child: _LearningCard(
        title: 'Sketch Challenge',
        imagePath: AssetPaths.sketchChallenge,
        ...
      ),
    ),
    const SizedBox(width: 14), // Jarak pemisah antar kartu

    // Kartu Kanan: Jelajah Cilik (50% lebar layar minus jarak)
    Expanded(
      child: _LearningCard(
        title: 'Jelajah Cilik',
        imagePath: AssetPaths.jelajahCilik,
        ...
      ),
    ),
  ],
)
```
*Kenapa dua `Expanded` dipisah `SizedBox(width: 14)`?* Ini adalah pola standar Flutter untuk membagi 2 kolom secara simetris sempurna tanpa perlu menghitung lebar layar secara manual.

#### 4. Banner Sketch-to-Story (`_buildSketchToStoryBanner`, Baris 298–380):
```dart
Row(
  children: [
    // 45% porsi lebar untuk gambar ilustrasi
    Expanded(
      flex: 5,
      child: Image.asset(AssetPaths.sketchToStory, fit: BoxFit.contain),
    ),
    const SizedBox(width: 12),

    // 55% porsi lebar untuk teks judul & tombol call-to-action
    Expanded(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Sketch-to-Story', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const Text('Ubah gambarmu jadi cerita', ...),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const Text('Mulai Bercerita', style: TextStyle(color: Color(0xFF00A3FF))),
          ),
        ],
      ),
    ),
  ],
)
```
*Kenapa `flex: 5` dan `flex: 6`?* Pembagian rasio 5:6 memberikan ruang yang pas agar teks "Sketch-to-Story" dan tombolnya tidak sesak, sementara ilustrasi di sebelah kiri tetap proporsional.

#### 5. Header Misi & Bilah Segmen Level (`home_screen.dart`, Baris 382–435):
```dart
// Baris Header Misi:
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Judul di kiri mentok, link di kanan mentok
  children: [
    const Text('Misi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
    GestureDetector(
      onTap: _onOpenMissions,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lihat semua', style: TextStyle(color: Color(0xFF5B34EA))),
          SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: Color(0xFF5B34EA)),
        ],
      ),
    ),
  ],
)

// Baris 4 Segmen Progress Bar Misi:
Row(
  children: List.generate(4, (index) {
    return Expanded( // Keempat bilah otomatis membagi rata 100% lebar
      child: Container(
        height: 8,
        margin: EdgeInsets.only(
          left: index == 0 ? 0 : 4,
          right: index == 3 ? 0 : 4,
        ),
        decoration: BoxDecoration(
          color: index == 0 ? const Color(0xFF5B34EA) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }),
)
```
*Kenapa `List.generate` dengan `Expanded`?* Empat garis progress segmen otomatis menyesuaikan lebar layar perangkat apapun dengan celah antar-garis tepat 8 px (`4 px kanan + 4 px kiri`).

---

## RINGKASAN ATURAN LAYOUT UI FLUTTER

1. **`Stack`** digunakan ketika ada elemen yang harus menumpuk di atas elemen lain (misal: background di bawah, form di tengah, tombol back di atas).
2. **`Column`** digunakan untuk menyusun urutan tampilan vertikal (atas ke bawah).
3. **`Row`** digunakan untuk menyusun elemen secara horizontal (kiri ke kanan).
4. **`Expanded`** digunakan di dalam `Row` atau `Column` agar anak widget mengambil sisa ruang yang tersedia, membagi rata porsi (50:50 atau 1/3), dan mencegah *render overflow* saat teks panjang.
5. **`Flexible` dengan `flex`** digunakan jika ingin pembagian persentase dinamis (misal: 5 bagian untuk gambar, 6 bagian untuk teks).
6. **`Spacer`** digunakan untuk mendorong elemen secara elastis ke tepi tanpa perlu menentukan ukuran `SizedBox` tetap.
7. **`Positioned`** hanya bekerja di dalam `Stack` untuk menentukan koordinat pasti `top`, `bottom`, `left`, `right`.
