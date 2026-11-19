import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../features/history/models/history_artwork_model.dart';
import '../../features/history/repositories/history_repository.dart';
import 'api_error.dart';

class RemoteHistoryRepository implements HistoryRepository {
  RemoteHistoryRepository({
    required this.baseUrl,
    required this.tokenProvider,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String? Function() tokenProvider;
  final http.Client _client;

  @override
  Future<List<HistoryArtwork>> fetchHistory() async {
    final token = tokenProvider();
    if (token == null || token.isEmpty) {
      throw const AppFailure(
        message: 'Sesi kamu sudah berakhir. Silakan masuk lagi.',
        code: 'UNAUTHENTICATED',
      );
    }
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    try {
      final response = await _client
          .get(
            Uri.parse('$base/history?limit=100'),
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw appFailureFromResponse(response);
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return const [];
      final items = decoded['items'];
      if (items is! List) return const [];
      return items.whereType<Map<String, dynamic>>().map((item) {
        final title = _stringValue(item['title']) ?? 'Karya';
        final score = _asInt(item['score']);
        return HistoryArtwork(
          id: _stringValue(item['id']) ?? title,
          title: title,
          levelLabel: item['type'] == 'sketch'
              ? 'Sketch Challenge'
              : 'Jelajah Cilik',
          dateLabel: _date(item['created_at'] as String?),
          imageAssetPath: '',
          imageUrl:
              _stringValue(item['artwork_image_url']) ??
              _stringValue(item['image_url']),
          status: ArtworkStatus.completed,
          earnedStars: score > 15
              ? 3
              : score > 10
              ? 2
              : 1,
          totalStars: 3,
        );
      }).toList();
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw const AppFailure(
        message: 'Riwayat gagal dimuat. Coba lagi.',
        isRetryable: true,
      );
    }
  }

  static int _asInt(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  String? _stringValue(Object? value) =>
      value is String && value.trim().isNotEmpty ? value : null;

  String _date(String? value) {
    if (value == null) return '-';
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }
}
