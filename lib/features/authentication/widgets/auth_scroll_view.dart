import 'package:flutter/material.dart';

/// Daftar isi layar autentikasi yang tidak "ketarik".
///
/// Di Android, [ListView] dengan physics clamping tetap memunculkan efek
/// overscroll *stretch*: isi halaman ikut memanjang saat ditarik melewati
/// batas. Di layar autentikasi efek itu dimatikan supaya halaman terasa
/// diam, sementara isi yang terlalu panjang tetap bisa di-scroll.
class AuthScrollView extends StatelessWidget {
  const AuthScrollView({
    super.key,
    required this.padding,
    required this.children,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  });

  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    final behavior = ScrollConfiguration.of(context)
        .copyWith(overscroll: false, scrollbars: false);

    return ScrollConfiguration(
      behavior: behavior,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: keyboardDismissBehavior,
        padding: padding,
        children: children,
      ),
    );
  }
}
