import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../features/sketch_challenge/models/level_item_model.dart';
import '../../features/sketch_challenge/repositories/sketch_challenge_repository.dart';
import 'api_error.dart';

// Koordinat tetap per level_number (zigzag bawah→atas)
const _kPositions = [
  (xRatio: 0.58, yRatio: 0.84), // level 1
  (xRatio: 0.30, yRatio: 0.70), // level 2
  (xRatio: 0.56, yRatio: 0.58), // level 3
  (xRatio: 0.28, yRatio: 0.45), // level 4
  (xRatio: 0.58, yRatio: 0.32), // level 5
];

class RemoteSketchChallengeLevelRepository
    implements SketchChallengeLevelRepository {
  RemoteSketchChallengeLevelRepository({
    required this.baseUrl,
    required this.tokenProvider,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String? Function() tokenProvider;
  final http.Client _client;

  @override
  Future<List<LevelItem>> fetchLevels() async {
    final token = tokenProvider();
    if (token == null || token.isEmpty) {
      throw const AppFailure(
        message: 'Sesi kamu sudah berakhir. Silakan masuk lagi.',
        code: 'UNAUTHENTICATED',
      );
    }

    final uri = Uri.parse(
      '${baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl}/sketch-challenge/levels',
    );

    final http.Response response;
    try {
      response = await _client.get(uri, headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
    } on Object {
      throw const AppFailure(
        message: 'Tidak bisa menghubungi server. Periksa jaringan kamu.',
        isRetryable: true,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw appFailureFromResponse(response);
    }

    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final items = decoded['levels'] as List<dynamic>;
      return items
          .whereType<Map<String, dynamic>>()
          .map(_toLevel)
          .toList(growable: false);
    } catch (_) {
      throw const AppFailure(
        message: 'Data level tidak bisa dibaca. Coba lagi.',
        isRetryable: true,
      );
    }
  }

  LevelItem _toLevel(Map<String, dynamic> json) {
    final levelNumber = (json['level_number'] as num?)?.toInt() ?? 1;
    final pos = levelNumber <= _kPositions.length
        ? _kPositions[levelNumber - 1]
        : _kPositions.last;

    final status = switch (json['status'] as String?) {
      'completed' => LevelStatus.completed,
      'active' => LevelStatus.active,
      _ => LevelStatus.locked,
    };

    return LevelItem(
      levelNumber: levelNumber,
      title: json['title'] as String? ?? 'Level $levelNumber',
      subtitle: json['subtitle'] as String? ?? '+20 Bintang',
      status: status,
      promptId: json['id'] as String? ?? '',
      highStars: (json['high_stars'] as num?)?.toInt() ?? 0,
      xRatio: pos.xRatio,
      yRatio: pos.yRatio,
    );
  }
}
