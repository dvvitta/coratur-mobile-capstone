import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_failure.dart';
import '../repositories/auth_repository.dart';
import '../widgets/auth_colors.dart';
import '../widgets/auth_scroll_view.dart';

/// Ditampilkan setelah pendaftaran saat backend mewajibkan verifikasi email.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.authRepository,
    this.resendCooldown = const Duration(seconds: 60),
  });

  final String email;
  final AuthRepository? authRepository;
  final Duration resendCooldown;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;
  late int _secondsLeft;
  var _sending = false;

  bool get _canResend => _secondsLeft == 0 && !_sending;

  @override
  void initState() {
    super.initState();
    // Mulai tanpa cooldown: user boleh langsung minta email baru.
    // Cooldown hanya dimulai setelah pengiriman berhasil.
    _secondsLeft = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    if (_secondsLeft <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resend() async {
    if (!_canResend) return;

    setState(() => _sending = true);
    try {
      if (widget.authRepository != null) {
        await widget.authRepository!.resendVerification(email: widget.email);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tautan verifikasi sudah dikirim ulang. Cek inbox kamu.',
          ),
        ),
      );
      setState(() {
        _sending = false;
        _secondsLeft = widget.resendCooldown.inSeconds;
      });
      _startCountdown();
    } on AppFailure catch (failure) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
      arguments: widget.email,
    );
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    _goToLogin();
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
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AuthScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: const Color(0xFFF3F3F5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        key: const Key('verify_email_back'),
                        customBorder: const CircleBorder(),
                        onTap: _onBack,
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.chevron_left,
                            size: 28,
                            color: AuthColors.title,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDE8FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 54,
                        color: AuthColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Cek email kamu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AuthColors.title,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      text: 'Kami mengirim tautan verifikasi ke\n',
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: AuthColors.muted,
                      ),
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AuthColors.title,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F5FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E1FF)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: AuthColors.accent,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Klik tautan di email untuk mengaktifkan akun, '
                            'baru setelah itu kamu bisa masuk. Cek folder spam '
                            'kalau email belum terlihat.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Color(0xFF5C5675),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      key: const Key('verify_email_login'),
                      onPressed: _goToLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: AuthColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Sudah verifikasi? Masuk'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    key: const Key('verify_email_resend'),
                    onPressed: _canResend ? _resend : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AuthColors.accent,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : Text(
                            _secondsLeft > 0
                                ? 'Kirim ulang email dalam ${_secondsLeft}s'
                                : 'Kirim ulang email verifikasi',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
