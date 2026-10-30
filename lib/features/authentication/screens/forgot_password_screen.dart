import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../repositories/auth_repository.dart';
import '../widgets/auth_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/forgot_password_elephant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    this.authRepository,
  });

  final AuthRepository? authRepository;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _submitting = false;
  var _hasInput = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _emailController.text.trim().isNotEmpty;
    if (hasText != _hasInput) {
      setState(() => _hasInput = hasText);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _submitting) return;

    final email = _emailController.text.trim();
    setState(() => _submitting = true);

    try {
      if (widget.authRepository != null) {
        await widget.authRepository!.forgotPassword(email: email);
      }
      if (!mounted) return;

      Navigator.of(context).pushNamed(
        AppRoutes.verifyResetCode,
        arguments: email,
      );
    } on AppFailure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email wajib diisi';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(email)) {
      return 'Format email tidak valid';
    }
    return null;
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
                        key: const Key('forgot_password_back'),
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
                  const SizedBox(height: 20),
                  const Text(
                    'Lupa Sandi',
                    key: Key('forgot_password_title'),
                    style: TextStyle(
                      color: AuthColors.title,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkin email kamu dulu yuk buat reset sandinya!',
                    key: Key('forgot_password_subtitle'),
                    style: TextStyle(
                      color: AuthColors.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: ForgotPasswordElephant(width: 268),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: AuthTextField(
                      key: const Key('forgot_password_email'),
                      label: 'Your Email',
                      hintText: 'Enteryouremail',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      prefix: const Icon(
                        Icons.mail_outline_rounded,
                        color: AuthColors.muted,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      key: const Key('forgot_password_submit'),
                      onPressed: _submitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: _hasInput
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
                          : const Text('Reset Password'),
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
