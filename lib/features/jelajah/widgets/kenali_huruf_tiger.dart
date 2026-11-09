import 'package:flutter/material.dart';

class KenaliHurufTiger extends StatelessWidget {
  const KenaliHurufTiger({
    super.key,
    required this.mouthOpen,
    required this.headPose,
    required this.width,
    required this.height,
  });

  final bool mouthOpen;
  final int headPose;
  final double width;
  final double height;

  String get _assetPath {
    if (headPose == 1) return 'assets/karakter/tiger right.png';
    if (headPose == 2) return 'assets/karakter/tiger left.png';
    return mouthOpen
        ? 'assets/karakter/tiger speak.png'
        : 'assets/karakter/tiger idle.png';
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      width: width,
      height: height,
      fit: BoxFit.fill,
      gaplessPlayback: true,
    );
  }
}
