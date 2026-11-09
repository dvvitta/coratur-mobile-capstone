import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class JelajahHeader extends StatelessWidget {
  const JelajahHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final pencilHeight = MediaQuery.sizeOf(context).width * 0.36;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      key: const Key('jelajah_back_button'),
                      customBorder: const CircleBorder(),
                      onTap: onBack,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C42F5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x336C42F5),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Jelajah Cilik',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4632AB),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(right: 96),
                child: Text(
                  'Yuk, jelajahi dunia baru lewat membaca, '
                  'berhitung, dan banyak lagi!',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF564F85),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -16,
          child: IgnorePointer(
            child: Image.asset(
              AssetPaths.jelajahPencil,
              key: const Key('jelajah_pencil_asset'),
              height: pencilHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
