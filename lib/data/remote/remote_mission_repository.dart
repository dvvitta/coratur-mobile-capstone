import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/asset_paths.dart';
import '../../core/errors/app_failure.dart';
import '../../features/missions/models/mission_item.dart';
import '../../features/missions/repositories/mission_repository.dart';
import 'api_error.dart';

/// Mengambil daftar misi dari backend (`GET /api/v1/missions`).
///
/// Endpoint ini terproteksi, jadi setiap permintaan membawa Bearer access
/// token yang sedang aktif di sesi.
class RemoteMissionRepository implements MissionRepository {
  RemoteMissionRepository({
    required this.baseUrl,
    required this.tokenProvider,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String? Function() tokenProvider;
  final http.Client _client;

  static const _categoryByActivity = {
    'sketch_challenge': 'Sketch Challenge',
    'explore': 'Jelajah Cilik',
    'story': 'Sketch-to-Story',
    'mixed': 'Petualangan hari ini',
  };

  static const _iconByActivity = {
    'sketch_challenge': AssetPaths.missionApple,
    'explore': AssetPaths.missionGames,
    'story': AssetPaths.missionStory,
    'mixed': AssetPaths.missionPalette,
  };

  /// `icon_key` dari database dipetakan ke aset lokal yang tersedia.
  static const _iconByKey = {
    'apple': AssetPaths.missionApple,
    'sketch': AssetPaths.missionApple,
    'palette': AssetPaths.missionPalette,
    'colors': AssetPaths.missionPalette,
    'games': AssetPaths.missionGames,
    'explore': AssetPaths.missionGames,
    'story': AssetPaths.missionStory,
  };

  @override
  Future<List<MissionItem>> fetchMissions() async {
    final token = tokenProvider();
    if (token == null || token.isEmpty) {
      throw const AppFailure(
        message: 'Sesi kamu sudah berakhir. Silakan masuk lagi.',
        code: 'UNAUTHENTICATED',
      );
    }

    final http.Response response;
    try {
      response = await _client.get(
        _missionsUri(),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
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
      final decoded = jsonDecode(response.body);
      final items = decoded is Map<String, dynamic> ? decoded['items'] : null;
      if (items is! List) {
        return const [];
      }
      return items
          .whereType<Map<String, dynamic>>()
          .map(_toMission)
          .toList(growable: false);
    } catch (_) {
      throw const AppFailure(
        message: 'Data misi tidak bisa dibaca. Coba lagi.',
        isRetryable: true,
      );
    }
  }

  Uri _missionsUri() {
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$cleanBase/missions')
        .replace(queryParameters: {'limit': '50'});
  }

  MissionItem _toMission(Map<String, dynamic> json) {
    final activity = json['activity_type'] as String? ?? 'mixed';
    final status = switch (json['status']) {
      'completed' => MissionStatus.completed,
      'in_progress' => MissionStatus.inProgress,
      _ => MissionStatus.notStarted,
    };
    final target = _asInt(json['target']);
    final iconKey = json['icon_key'] as String?;

    return MissionItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Misi',
      category: _categoryByActivity[activity] ?? 'Petualangan hari ini',
      currentProgress: _asInt(json['progress']),
      totalProgress: target > 0 ? target : 1,
      reward: _asInt(json['reward_points']),
      status: status,
      iconPath:
          _iconByKey[iconKey] ??
          _iconByActivity[activity] ??
          AssetPaths.missionApple,
      actionLabel: switch (status) {
        MissionStatus.completed => 'Selesai',
        MissionStatus.inProgress => 'Lanjut',
        MissionStatus.notStarted => 'Mulai',
      },
    );
  }

  static int _asInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value') ?? 0;
  }
}
