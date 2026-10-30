import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../repositories/auth_repository.dart';
import '../widgets/auth_colors.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  const VerifyResetCodeScreen({
    super.key,
    this.email = 'psyy@gmail.com',
    this.authRepository,
  });

  final String email;
  final AuthRepository? authRepository;

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  var _submitting = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();
  bool get _isComplete => _code.length == 4;

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.forgotPassword);
  }

  Future<void> _resend() async {
    try {
      if (widget.authRepository != null) {
        await widget.authRepository!.forgotPassword(email: widget.email);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kode baru dikirim ke ${widget.email}')),
      );
    } on AppFailure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  Future<void> _verify() async {
    if (!_isComplete || _submitting) return;

    setState(() => _submitting = true);

    try {
      if (widget.authRepository != null) {
        await widget.authRepository!.verifyResetCode(
          email: widget.email,
          code: _code,
        );
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode terverifikasi!')),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } on AppFailure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
              constraints: const BoxConstraints(maxWidth: Breakpoints.compact),
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: const Color(0xFFF3F3F5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        key: const Key('verify_code_back'),
                        customBorder: const CircleBorder(),
                        onTap: _onBack,
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.chevron_left,
                            size: 26,
                            color: AuthColors.title,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Check your email',
                    key: Key('verify_code_title'),
                    style: TextStyle(
                      color: AuthColors.title,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'kami teleah mengirim kode ke ${widget.email}',
                    key: const Key('verify_code_email_info'),
                    style: const TextStyle(
                      color: AuthColors.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'masukkan 4 digit kode untuk menreset sandi',
                    key: Key('verify_code_instruction'),
                    style: TextStyle(
                      color: AuthColors.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox.square(
                        dimension: 64,
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.backspace &&
                                _controllers[index].text.isEmpty &&
                                index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          },
                          child: TextFormField(
                            key: Key('verify_digit_$index'),
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AuthColors.title,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              counterText: '',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AuthColors.fieldBorder,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AuthColors.accent,
                                  width: 1.6,
                                ),
                              ),
                            ),
                            onChanged: (v) => _onDigitChanged(index, v),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      key: const Key('verify_code_submit'),
                      onPressed: _isComplete && !_submitting ? _verify : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _isComplete
                            ? AuthColors.accent
                            : const Color(0xFF8A76B9),
                        disabledBackgroundColor: const Color(0xFF8A76B9)
                            .withValues(alpha: 0.6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Verify Code'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Haven't got the email yet? ",
                        style: TextStyle(
                          color: AuthColors.muted,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        key: const Key('verify_code_resend'),
                        onTap: _resend,
                        child: const Text(
                          'Resend email',
                          style: TextStyle(
                            color: AuthColors.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
