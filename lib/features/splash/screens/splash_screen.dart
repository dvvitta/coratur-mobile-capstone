import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/asset_paths.dart';
import '../controllers/splash_controller.dart';

/// Urutan sesuai frame desain:
/// 1. layar putih
/// 2. logo fade-in di tengah
/// 3. logo naik, background splash 3 fade-in
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.controller = const SplashController(),
    this.duration = SplashTimings.total,
  });

  final SplashController controller;
  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

abstract final class SplashTimings {
  static const Duration total = Duration(milliseconds: 5600);
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoMove;
  late final Animation<double> _backgroundOpacity;

  var _started = false;
  var _navigated = false;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(vsync: this, duration: widget.duration);
    _logoOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.06, 0.28, curve: Curves.easeOut),
    );
    _logoMove = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.40, 0.58, curve: Curves.easeInOutCubic),
    );
    _backgroundOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.40, 0.58, curve: Curves.easeOut),
    );
    _intro.addStatusListener(_onIntroStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    unawaited(_precacheAssets());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _intro.isAnimating || _intro.isCompleted) {
        return;
      }
      unawaited(_intro.forward());
    });
  }

  Future<void> _precacheAssets() async {
    try {
      await Future.wait<void>([
        precacheImage(const AssetImage(AssetPaths.logo), context),
        precacheImage(const AssetImage(AssetPaths.splashFullscreen3), context),
      ]);
    } on Object {
      // Aset rusak ditangani Image.errorBuilder; splash tetap jalan.
    }
  }

  void _onIntroStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _navigated) {
      return;
    }
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(widget.controller.nextRoute);
    });
  }

  @override
  void dispose() {
    _intro.removeStatusListener(_onIntroStatus);
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: AnimatedBuilder(
          animation: _intro,
          builder: (context, child) {
            return _SplashStage(
              logoOpacity: _logoOpacity.value,
              logoMove: _logoMove.value,
              backgroundOpacity: _backgroundOpacity.value,
            );
          },
        ),
      ),
    );
  }
}

class _SplashStage extends StatelessWidget {
  const _SplashStage({
    required this.logoOpacity,
    required this.logoMove,
    required this.backgroundOpacity,
  });

  final double logoOpacity;
  final double logoMove;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final logoWidth = (width * 0.78).clamp(168.0, 360.0);
        final logoHeight = logoWidth * (1024 / 1536);
        final startCenterY = height * 0.50;
        final endCenterY = height * 0.22;
        final logoCenterY =
            startCenterY + (endCenterY - startCenterY) * logoMove;
        final logoTop = (logoCenterY - logoHeight / 2).clamp(
          0.0,
          height - logoHeight,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Colors.white),
            IgnorePointer(
              child: Opacity(
                opacity: backgroundOpacity.clamp(0.0, 1.0),
                child: Image.asset(
                  AssetPaths.splashFullscreen3,
                  key: const Key('splash_background'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  gaplessPlayback: true,
                  excludeFromSemantics: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.expand();
                  },
                ),
              ),
            ),
            Positioned(
              top: logoTop,
              left: 0,
              right: 0,
              height: logoHeight,
              child: IgnorePointer(
                child: Opacity(
                  opacity: logoOpacity.clamp(0.0, 1.0),
                  child: Image.asset(
                    AssetPaths.logo,
                    key: const Key('splash_logo'),
                    width: logoWidth,
                    height: logoHeight,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                    semanticLabel: 'SKETCHOO',
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
