import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'features/badges/screens/badge_collection_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColoredBox(
        color: const Color(0xFFE9E6F2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const width = 412.0;
            const height = 917.0;
            final scale = math.min(
              constraints.maxWidth / width,
              constraints.maxHeight / height,
            );
            return Center(
              child: SizedBox(
                width: width * scale,
                height: height * scale,
                child: FittedBox(
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: const BadgeCollectionScreen(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
