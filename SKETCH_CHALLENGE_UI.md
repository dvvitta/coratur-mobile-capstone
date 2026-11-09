# DOKUMENTASI TEKNIS UI: SKETCH CHALLENGE SCREEN
**File Sumber:** 
* `lib/features/sketch_challenge/screens/sketch_challenge_screen.dart`
* `lib/features/sketch_challenge/widgets/sketch_canvas_painter.dart`
* `lib/features/sketch_challenge/models/sketch_challenge_models.dart`

---

## 1. IKHTISAR & ALUR VISUAL
Layar **Sketch Challenge** adalah arena menggambar interaktif edukatif untuk anak-anak:
1. **Header Atas:** Tombol navigasi kembali, judul dua baris ("Sketch Challenge"), dan badge perolehan skor bintang.
2. **Instruksi & Progress:** Kalimat ajakan menggambar disertai bilah progres step (`1/5` hingga `5/5`).
3. **Kanvas Utama (Drawing Board):**
   - Baris atas: Label nama hewan (mis. "Bebek"), tombol Undo, dan tombol Eraser/Hapus semua.
   - Area tumpukan (*Stack*): Garis putus-putus transparan format SVG sebagai pemandu di bawah, dan lapisan kanvas sentuh jemari di atasnya.
4. **Palet Warna:** 5 tombol lingkaran warna cerah yang membesar dan memunculkan centang saat dipilih.
5. **Tombol Selesai:** Tombol aksi utama di bagian paling bawah untuk menyimpan karya dan melanjutkan ke halaman hasil (*Result Screen*).

---

## 2. ASAL & LOKASI PEMANGGILAN ASET GAMBAR
Semua path aset didefinisikan terpusat di `lib/core/constants/asset_paths.dart`:

```dart
// lib/core/constants/asset_paths.dart
static const star = 'assets/images/star.png';
static const sketchGuideBebek = 'assets/sketch challenge/hewan/bebek.svg';
static const sketchGuideKucing = 'assets/sketch challenge/hewan/kucing.svg';
static const sketchGuideIkan = 'assets/sketch challenge/hewan/ikan.svg';
static const sketchGuideKupuKupu = 'assets/sketch challenge/hewan/kupu-kupu.svg';
static const sketchGuideKuraKura = 'assets/sketch challenge/hewan/kura-kura.svg';
```

### Titik Pemanggilan di `sketch_challenge_screen.dart`:
1. **Daftar Prompt Level (Baris 38–74):**
   ```dart
   final List<SketchChallengePrompt> _prompts = const [
     SketchChallengePrompt(
       id: 'bebek',
       title: 'Bebek',
       instruction: 'Ikuti garis putus - putus, gambar\nbebek lucu!',
       stepText: '1/5',
       guideAssetPath: AssetPaths.sketchGuideBebek,
     ),
     // Kucing, Ikan, Kupu-kupu, Kura-kura ...
   ];
   ```
2. **Ikon Bintang Badge Skor (Baris 293–298):**
   ```dart
   Image.asset(
     AssetPaths.star, // 'assets/images/star.png'
     width: 26,
     height: 26,
     fit: BoxFit.contain,
   )
   ```
3. **Ikon Penghapus Toolbar Kanvas (Baris 427):**
   ```dart
   _buildCanvasAssetButton(
     key: const Key('sketch_clear_button'),
     assetPath: 'assets/images/eraser.png',
     onTap: _clearCanvas,
   )
   ```
4. **Pemandu Garis Putus-Putus SVG (Baris 498–507):**
   ```dart
   Widget _buildGuideWidget(String path) {
     if (path.toLowerCase().endsWith('.svg')) {
       return SvgPicture.asset(path, fit: BoxFit.contain);
     }
     return Image.asset(path, fit: BoxFit.contain);
   }
   ```
   *Fungsi:* Menggunakan `SvgPicture.asset` agar garis kurva vektor tetap tajam dan tidak pecah pada resolusi layar tablet maupun ponsel tinggi.

---

## 3. STRUKTUR UTAMA LAYAR (`Column` & `Expanded`)
Tampilan diatur dari atas ke bawah menggunakan satu `Column` utama di dalam `SafeArea` (Baris 209–233):

```dart
Scaffold(
  backgroundColor: const Color(0xFFF5F6FE), // Warna lavender sangat muda
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _buildHeader(),                         // 1. Header (Tinggi adaptif)
          const SizedBox(height: 12),
          _buildTitleAndStep(),                   // 2. Instruksi & Progress (Tinggi adaptif)
          const SizedBox(height: 12),
          Expanded(child: _buildDrawingCanvas()), // 3. Kanvas (Menyerap seluruh sisa tinggi layar)
          const SizedBox(height: 12),
          _buildPalette(),                        // 4. Palet 5 Warna (Tinggi tetap)
          const SizedBox(height: 12),
          _buildFinishButton(),                   // 5. Tombol Selesai (Tinggi 52 px)
          const SizedBox(height: 12),
        ],
      ),
    ),
  ),
)
```

### Mengapa Kanvas Dibungkus `Expanded`?
Jika tinggi kanvas dikunci mati (misal `height: 400`), aplikasi akan mengalami:
* *Overflow* (layar kuning-hitam) pada HP kecil berlayar pendek.
* Ruang kosong mubazir pada tablet atau HP berlayar panjang.
Dengan `Expanded`, kanvas bertindak elastis: otomatis memanjang atau memendek menyesuaikan sisa ruang vertikal perangkat.

---

## 4. BEDAH DETAIL WIDGET & PENGATURAN LAYOUT

### A. Bagian 1: Header Atas (`_buildHeader`, Baris 236–328)
Disusun menggunakan `Row` dengan 3 elemen sejajar horizontal:

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // 1. KIRI: Tombol Kembali Bulat Ungu
    Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFF8B5CF6), // Ungu tombol
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
      ),
    ),

    const SizedBox(width: 14),

    // 2. TENGAH: Judul Dua Baris (Expanded menyerap ruang kosong)
    const Expanded(
      child: Text(
        'Sketch\nChallenge',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF3730A3),
          height: 1.15,
        ),
      ),
    ),

    // 3. KANAN: Kapsul Badge Skor Bintang
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE8), // Kuning krem lembut
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Lebar hanya selebar isinya
        children: [
          Image.asset(AssetPaths.star, width: 26, height: 26),
          const SizedBox(width: 8),
          Column( // Tumpuk vertikal: label 'Skor' di atas, angka di bawah
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Skor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              Text('${widget.initialScore}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    ),
  ],
)
```
* **Peran `Expanded` pada Judul:** Menjamin judul teks berada di antara tombol back dan badge skor tanpa pernah saling tumpang-tindih.

---

### B. Bagian 2: Instruksi & Progress Bar (`_buildTitleAndStep`, Baris 331–372)
Disusun menggunakan kombinasi `Column` (luar) dan `Row` (dalam):

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Teks instruksi: "Ikuti garis putus - putus, gambar bebek lucu!"
    Text(_currentPrompt.instruction, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),

    const SizedBox(height: 10),

    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Expanded: Menjadikan bar indikator selebar sisa ruang horizontal
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 2 / 5, // Nilai progres aktif
              minHeight: 10,
              backgroundColor: Color(0xFFE5DEFF),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B4DFF)),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Teks penanda langkah di ujung kanan: "1/5"
        Text(
          _currentPrompt.stepText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  ],
)
```

---

### C. Bagian 3: Kanvas Gambar Interaktif (`_buildDrawingCanvas`, Baris 375–495)
Dibungkus kontainer putih ber-radius 24 dengan bayangan halus (*box-shadow*). Menggunakan `Column`:
* **Baris Atas (Toolbar):** Label judul hewan & tombol aksi alat.
* **Baris Bawah (`Expanded` ➔ `Stack`):** Area menggambar berlapis.

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: Column(
    children: [
      // 1. TOOLBAR KANVAS ATAS
      Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pisahkan badge kiri & tombol kanan
          children: [
            // Badge Nama Hewan (Kiri)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFEBE6FD), borderRadius: BorderRadius.circular(20)),
              child: Text(_currentPrompt.title, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),

            // Tombol Alat (Kanan)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCanvasToolButton(
                  key: const Key('sketch_undo_button'),
                  icon: Icons.undo_rounded,
                  onTap: _undo, // Menghapus 1 tarikan garis terakhir
                ),
                const SizedBox(width: 8),
                _buildCanvasAssetButton(
                  key: const Key('sketch_clear_button'),
                  assetPath: 'assets/images/eraser.png',
                  onTap: _clearCanvas, // Menghapus seluruh kanvas bersih kembali
                ),
              ],
            ),
          ],
        ),
      ),

      // 2. AREA GAMBAR BERLAPIS (STACK)
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // LAYER 1 (DASAR): Template Garis Putus-Putus Vektor
                if (_currentPrompt.guideAssetPath != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildGuideWidget(_currentPrompt.guideAssetPath!),
                  ),

                // LAYER 2 (ATAS): Kanvas Penerima Sentuhan Jari
                Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (event) { ... },  // Mulai garis baru
                  onPointerMove: (event) { ... },  // Lanjutkan titik kurva
                  onPointerUp: (_) => _activeLine = null,
                  child: CustomPaint(
                    painter: SketchCanvasPainter(lines: _lines), // Menggambar goresan
                    size: Size.infinite,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ],
  ),
)
```

---

## 5. SISTEM ENGINE CORETAN KANVAS (`CustomPainter`)
**File:** `lib/features/sketch_challenge/widgets/sketch_canvas_painter.dart`

Sentuhan pengguna diubah menjadi objek `DrawnLine` yang terdiri dari titik-titik `Offset(x, y)`:
```dart
class SketchCanvasPainter extends CustomPainter {
  const SketchCanvasPainter({required this.lines});
  final List<DrawnLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      if (line.points.isEmpty) continue;

      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round // Ujung garis dibuat membulat halus
        ..strokeJoin = StrokeJoin.round // Sambungan antar titik dibuat tumpul halus
        ..strokeWidth = line.strokeWidth // Tebal garis 5.0 px
        ..style = PaintingStyle.stroke;

      // Kasus 1: Pengguna hanya mengetuk 1 titik (tap)
      if (line.points.length == 1) {
        canvas.drawCircle(line.points.first, line.strokeWidth / 2, paint..style = PaintingStyle.fill);
        continue;
      }

      // Kasus 2: Pengguna menggeser jari membentuk garis kurva (drag)
      final path = Path()..moveTo(line.points.first.dx, line.points.first.dy);
      for (int i = 1; i < line.points.length; i++) {
        path.lineTo(line.points[i].dx, line.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SketchCanvasPainter oldDelegate) => true;
}
```

---

## 6. PALET 5 WARNA INTERAKTIF (`_buildPalette`, Baris 560–607)
Disusun menggunakan `Row` dengan pembagian jarak `MainAxisAlignment.spaceAround`:

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // Menjaga 5 lingkaran berjarak rata
    children: _paletteColors.map((color) {
      final isSelected = _selectedColor == color;
      return GestureDetector(
        onTap: () => setState(() => _selectedColor = color),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // Lingkaran aktif membesar jadi 44 px, yang lain 36 px:
          width: isSelected ? 44 : 36,
          height: isSelected ? 44 : 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 3) // Bingkai putih pada warna aktif
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? const Center(
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 20),
                )
              : null,
        ),
      );
    }).toList(),
  ),
)
```

Daftar 5 warna yang disediakan (`_paletteColors`, Baris 29–35):
1. **Ungu:** `Color(0xFF7C4DFF)`
2. **Merah Muda:** `Color(0xFFF472B6)`
3. **Kuning:** `Color(0xFFFACC15)`
4. **Hijau Mint:** `Color(0xFF34D399)`
5. **Biru:** `Color(0xFF3B82F6)`

---

## 7. TOMBOL SELESAI (`_buildFinishButton`, Baris 609–632)
```dart
SizedBox(
  height: 52, // Tinggi tombol ergonomis
  child: FilledButton(
    key: const Key('sketch_finish_button'),
    onPressed: _onFinish,
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFF7C4DFF), // Ungu primer
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18), // Sudut membulat modern
      ),
      elevation: 0,
    ),
    child: const Text(
      'Selesai',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    ),
  ),
)
```

---

## RINGKASAN PERAN WIDGET PADA SKETCH CHALLENGE

| Widget | Letak / Fungsi | Alasan Teknis Pemilihan |
| :--- | :--- | :--- |
| **`SafeArea`** | Pembungkus terluar layar | Mencegah konten tertusuk notch kamera atau taskbar gesture |
| **`Column`** | Layout utama vertikal | Menyusun urutan header ➔ instruksi ➔ kanvas ➔ palet ➔ tombol |
| **`Expanded`** | Membungkus `_buildDrawingCanvas()` | Kanvas otomatis menyerap seluruh sisa tinggi layar HP |
| **`Stack`** | Di dalam area kanvas | Menumpuk template garis panduan SVG di bawah dan coretan jari di atas |
| **`Row + Expanded`** | Di Progress Bar & Header | Menjaga bar progres dan teks judul merentang elastis di antara tombol |
| **`Row + spaceBetween`** | Toolbar Kanvas Atas | Memisahkan badge nama hewan di kiri dan tombol aksi (Undo/Eraser) di kanan |
| **`Row + spaceAround`** | Palet 5 Warna | Membagi jarak horizontal 5 lingkaran cat secara simetris di semua HP |
| **`AnimatedContainer`** | Tombol Warna Palet | Animasi pembesaran halus dari 36 px ke 44 px saat warna diklik |
| **`Listener + CustomPaint`**| Engine Gambar | Menangkap koordinat sentuhan jari dan merender garis kurva seketika |
