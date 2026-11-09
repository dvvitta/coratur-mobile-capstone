import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../../../data/mock/mock_auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../models/auth_tab.dart';
import '../services/remembered_email_store.dart';
import '../widgets/auth_form_sheet.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    this.initialTab = AuthTab.login,
    this.initialEmail,
    this.rememberedEmailStore,
    this.controller,
    this.playIntro = true,
    this.googleWebClientId,
  });

  final AuthTab initialTab;
  final String? initialEmail;

  /// Bila diisi, email login terakhir dipulihkan dan disimpan saat
  /// "Ingat saya" dicentang.
  final RememberedEmailStore? rememberedEmailStore;
  final AuthController? controller;
  final bool playIntro;
  final String? googleWebClientId;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final AuthController _controller;
  late final AnimationController _intro;
  late final Animation<Offset> _cardSlide;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  final _formKey = GlobalKey<FormState>();

  late AuthTab _tab;
  var _obscurePassword = true;
  var _obscureConfirmPassword = true;
  var _rememberMe = false;
  var _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        AuthController(repository: const MockAuthRepository());
    _tab = widget.initialTab;
    _name = TextEditingController();
    _email = TextEditingController(text: widget.initialEmail ?? '');
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic));
    if (widget.playIntro) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _intro.forward();
        }
      });
    } else {
      _intro.value = 1;
    }
    _restoreRememberedEmail();
  }

  Future<void> _restoreRememberedEmail() async {
    final store = widget.rememberedEmailStore;
    if (store == null) return;
    try {
      final saved = await store.read();
      if (!mounted || saved == null) return;
      // Jangan menimpa email yang sudah dibawa lewat rute (mis. reset sandi).
      if (_email.text.trim().isNotEmpty) return;
      setState(() {
        _email.text = saved;
        _rememberMe = true;
      });
    } on Object {
      // Penyimpanan lokal gagal: login tetap bisa dilakukan manual.
    }
  }

  Future<void> _persistRememberedEmail() async {
    final store = widget.rememberedEmailStore;
    if (store == null) return;
    try {
      if (_rememberMe) {
        await store.save(_email.text);
      } else {
        await store.clear();
      }
    } on Object {
      // Kegagalan menyimpan email tidak boleh menggagalkan login.
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _submitting = true);
    try {
      final outcome = await _controller.submit(
        tab: _tab,
        name: _name.text,
        email: _email.text,
        password: _password.text,
        confirmPassword: _confirmPassword.text,
        rememberMe: _rememberMe,
      );
      if (!mounted) {
        return;
      }

      if (_tab == AuthTab.login) {
        await _persistRememberedEmail();
        if (!mounted) {
          return;
        }
      }

      if (outcome.requiresEmailConfirmation) {
        // Akun belum aktif: arahkan ke layar verifikasi, bukan ke beranda.
        await Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.verifyEmail, arguments: outcome.email);
        return;
      }

      Navigator.of(context).pushReplacementNamed(_controller.homeRoute);
    } on AppFailure catch (failure) {
      if (!mounted) {
        return;
      }
      final needsVerification = failure.code == 'EMAIL_NOT_CONFIRMED';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          action: needsVerification
              ? SnackBarAction(
                  label: 'Verifikasi',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.verifyEmail,
                      arguments: _email.text.trim(),
                    );
                  },
                )
              : null,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _onGoogle() async {
    if (_submitting) return;
    final webClientId = widget.googleWebClientId?.trim() ?? '';
    if (webClientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Client ID Web Google belum diatur di .env.'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final google = GoogleSignIn.instance;
      await google.initialize(serverClientId: webClientId);
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AppFailure(
          message:
              'Google tidak memberikan ID token. Periksa konfigurasi OAuth.',
        );
      }

      await _controller.signInWithGoogle(idToken: idToken);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(_controller.homeRoute);
    } on AppFailure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Google gagal atau dibatalkan. Coba lagi.'),
        ),
      );
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AssetPaths.authBackground,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0,
                  end: -((MediaQuery.viewInsetsOf(context).bottom * 0.45).clamp(
                    0.0,
                    150.0,
                  )),
                ),
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                builder: (context, offsetY, child) => Transform.translate(
                  offset: Offset(0, offsetY),
                  child: child,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.compact,
                  ),
                  child: Column(
                    children: [
                      const SafeArea(
                        bottom: false,
                        child: SizedBox(height: 50),
                      ),
                      Expanded(
                        child: SlideTransition(
                          position: _cardSlide,
                          child: AuthFormSheet(
                            tab: _tab,
                            formKey: _formKey,
                            nameController: _name,
                            emailController: _email,
                            passwordController: _password,
                            confirmPasswordController: _confirmPassword,
                            obscurePassword: _obscurePassword,
                            obscureConfirmPassword: _obscureConfirmPassword,
                            rememberMe: _rememberMe,
                            submitting: _submitting,
                            onTabChanged: (tab) => setState(() => _tab = tab),
                            onToggleObscure: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                            onToggleObscureConfirm: () {
                              setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              );
                            },
                            onRememberChanged: (value) {
                              setState(() => _rememberMe = value);
                            },
                            onForgotPassword: () {
                              Navigator.of(context)
                                  .pushNamed(_controller.forgotPasswordRoute);
                            },
                            onSubmit: _submit,
                            onGoogle: _onGoogle,
                            validatorName: _controller.validateName,
                            validatorEmail: _controller.validateEmail,
                            validatorPassword: _tab == AuthTab.login
                                ? _controller.validatePassword
                                : _controller.validateRegisterPassword,
                            validatorConfirmPassword: (value) => _controller
                                .validateConfirmPassword(value, _password.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.compact,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 2,
                        shadowColor: const Color(0x1A000000),
                        child: InkWell(
                          key: const Key('auth_back'),
                          customBorder: const CircleBorder(),
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              CupertinoIcons.chevron_back,
                              size: 28,
                              color: Color(0xFF4A4763),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
