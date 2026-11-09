import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_failure.dart';

class MissionsLoadingView extends StatelessWidget {
  const MissionsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('missions_loading'),
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.6),
        ),
      ),
    );
  }
}

class MissionsEmptyView extends StatelessWidget {
  const MissionsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('missions_empty'),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_circle_outlined, size: 40, color: Color(0xFF9A97B0)),
          SizedBox(height: 10),
          Text(
            'Belum ada misi hari ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Misi baru akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class MissionsErrorView extends StatelessWidget {
  const MissionsErrorView({
    super.key,
    required this.failure,
    required this.isSessionExpired,
    required this.onRetry,
  });

  final AppFailure failure;
  final bool isSessionExpired;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('missions_error'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 36,
            color: Color(0xFFB91C1C),
          ),
          const SizedBox(height: 10),
          Text(
            failure.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF7F1D1D),
            ),
          ),
          const SizedBox(height: 14),
          if (isSessionExpired)
            FilledButton(
              key: const Key('missions_login'),
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5B34EA),
                foregroundColor: Colors.white,
              ),
              child: const Text('Masuk lagi'),
            )
          else
            OutlinedButton(
              key: const Key('missions_retry'),
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5B34EA),
                side: const BorderSide(color: Color(0xFF5B34EA)),
              ),
              child: const Text('Coba lagi'),
            ),
        ],
      ),
    );
  }
}
