import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../repositories/auth_repository.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scroll_view.dart';

abstract final class _Palette {
  static const title = Color(0xFF1C1C1E);
  static const subtitle = Color(0xFFA3A0B2);
  static const hint = Color(0xFFC8C4D6);
  static const fieldBorder = Color(0xFFE6E2F2);
  static const fieldFill = Color(0xFFFCFBFF);
  static const backButton = Color(0xFFF3F1F8);
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _submitting = false;

  @override
  void dispose() {
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

      Navigator.of(context)
          .pushNamed(AppRoutes.verifyResetCode, arguments: email);
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
    const radius = 28.0;

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
              child: AuthScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: _Palette.backButton,
                      shape: const CircleBorder(),
                      child: InkWell(
                        key: const Key('forgot_password_back'),
                        customBorder: const CircleBorder(),
                        onTap: _onBack,
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            CupertinoIcons.chevron_back,
                            size: 28,
                            color: _Palette.title,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Lupa Sandi',
                    key: Key('forgot_password_title'),
                    style: TextStyle(
                      color: _Palette.title,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkin email kamu dulu yuk buat reset sandinya!',
                    key: Key('forgot_password_subtitle'),
                    style: TextStyle(
                      color: _Palette.subtitle,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 268,
                    child: SvgPicture.asset(
                      AssetPaths.forgotPasswordElephant,
                      key: const Key('forgot_password_elephant'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Email',
                          style: TextStyle(
                            color: _Palette.title,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: const Key('forgot_password_email'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(
                            color: _Palette.title,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan email kamu',
                            hintStyle: const TextStyle(
                              color: _Palette.hint,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 18, right: 6),
                              child: Icon(
                                CupertinoIcons.envelope,
                                size: 18,
                                color: _Palette.hint,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 46,
                              minHeight: 20,
                            ),
                            filled: true,
                            fillColor: _Palette.fieldFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius),
                              borderSide: const BorderSide(
                                color: _Palette.fieldBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius),
                              borderSide: const BorderSide(
                                color: Color(0xFF7356F0),
                                width: 1.2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius),
                              borderSide: const BorderSide(
                                color: Color(0xFFE57373),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius),
                              borderSide: const BorderSide(
                                color: Color(0xFFE57373),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  AuthPrimaryButton(
                    key: const Key('forgot_password_submit'),
                    label: 'Reset Sandi',
                    submitting: _submitting,
                    onPressed: _submit,
                    height: 58,
                    fontSize: 18,
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
