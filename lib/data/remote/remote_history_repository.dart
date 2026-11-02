import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../features/history/models/history_artwork_model.dart';
import '../../features/history/repositories/history_repository.dart';

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
      final response = await _client.get(
        Uri.parse('$base/history?limit=100'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AppFailure(
          message: 'Riwayat gagal dimuat (${response.statusCode}).',
          isRetryable: true,
        );
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final items = decoded['items'] as List<dynamic>? ?? const [];
      return items.map((raw) {
        final item = raw as Map<String, dynamic>;
        final title = item['title'] as String? ?? 'Karya';
        final score = item['score'] as int? ?? 0;
        return HistoryArtwork(
          id: item['id'] as String? ?? title,
          title: title,
          levelLabel: item['type'] == 'sketch'
              ? 'Sketch Challenge'
              : 'Jelajah Cilik',
          dateLabel: _date(item['created_at'] as String?),
          imageAssetPath: '',
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

  String _date(String? value) {
    if (value == null) return '-';
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }
}
