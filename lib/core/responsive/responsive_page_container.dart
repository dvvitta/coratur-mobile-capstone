import 'package:flutter/material.dart';

import '../constants/breakpoints.dart';

/// Pembungkus halaman agar layout mobile dan layar lebar bisa dibedakan nanti.
class ResponsivePageContainer extends StatelessWidget {
  const ResponsivePageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth >= Breakpoints.medium
            ? Breakpoints.medium
            : double.infinity;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      },
    );
  }
}
