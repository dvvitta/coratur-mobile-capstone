import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../features/sketch_challenge/repositories/sketch_challenge_complete_repository.dart';
import 'api_error.dart';

class RemoteSketchChallengeCompleteRepository
    implements SketchChallengeCompleteRepository {
  RemoteSketchChallengeCompleteRepository({
    required this.baseUrl,
    required this.tokenProvider,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String? Function() tokenProvider;
  final http.Client _client;

  @override
  Future<SketchCompleteResult> completeLevel({
    required String levelId,
    required int strokeCount,
    required int totalPoints,
    required int durationSeconds,
    String? artworkImageUrl,
  }) async {
    final token = tokenProvider();
    if (token == null || token.isEmpty) {
      throw const AppFailure(
        message: 'Sesi kamu sudah berakhir. Silakan masuk lagi.',
        code: 'UNAUTHENTICATED',
      );
    }

    final uri = Uri.parse(
      '${baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl}/sketch-challenge/complete',
    );

    final body = <String, dynamic>{
      'level_id': levelId,
      'stroke_count': strokeCount,
      'total_points': totalPoints,
      'duration_seconds': durationSeconds,
      // ignore: use_null_aware_elements
      if (artworkImageUrl != null) 'artwork_image_url': artworkImageUrl,
    };

    final http.Response response;
    try {
      response = await _client.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(body),
      );
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
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return SketchCompleteResult(
        starsEarned: (json['stars_earned'] as num?)?.toInt() ?? 1,
        scoreAdded: (json['score_added'] as num?)?.toInt() ?? 10,
        totalStars: (json['total_stars'] as num?)?.toInt() ?? 0,
        unlockedLevelId: json['unlocked_level_id'] as String?,
        feedbackMessage: json['feedback_message'] as String? ?? 'Bagus!',
      );
    } catch (_) {
      throw const AppFailure(
        message: 'Respons server tidak bisa dibaca. Coba lagi.',
        isRetryable: true,
      );
    }
  }
}
