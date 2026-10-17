import '../../../core/constants/asset_paths.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.illustrationPath,
    required this.title,
    required this.body,
  });

  final String illustrationPath;
  final String title;
  final String body;
}

/// Teks mengikuti frame desain. Ilustrasi memakai cutout di `assets/images/`.
abstract final class OnboardingPages {
  static const pages = [
    OnboardingPageData(
      illustrationPath: AssetPaths.onboardIllustration1,
      title: 'Yuk, Mulai dengan\nmenggambar!',
      body: 'Tunjukkan kreatifitasmu dan bagaimana gambar kecilmu bisa berubah menjadi cerita seru penuh warna dan makna',
    ),
    OnboardingPageData(
      illustrationPath: AssetPaths.onboardIllustration2,
      title: 'Jelajahi dunia\npenuh pengetahuan!',
      body: 'ikuti berbagai aktivitas seru untuk melatih logika, bahasa dan daya imajinasimu',
    ),
    OnboardingPageData(
      illustrationPath: AssetPaths.onboardIllustration3,
      title: 'Gambar jadi cerita,\ncerita jadi petualangan!',
      body: 'Setiap coretanmu bisa berubah menjadi cerita fabel yang penuh warna dan makna',
    ),
  ];
}
