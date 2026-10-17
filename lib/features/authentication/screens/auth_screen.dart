import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../../../data/mock/mock_auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../models/auth_tab.dart';
import '../widgets/auth_colors.dart';
import '../widgets/auth_elephant.dart';
import '../widgets/auth_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    this.initialTab = AuthTab.login,
    this.controller,
    this.playIntro = true,
  });

  final AuthTab initialTab;
  final AuthController? controller;
  final bool playIntro;

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
  final _formKey = GlobalKey<FormState>();

  late AuthTab _tab;
  var _obscurePassword = true;
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
    _email = TextEditingController();
    _password = TextEditingController();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
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
  }

  @override
  void dispose() {
    _intro.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacementNamed(_controller.onboardingRoute);
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
      await _controller.submit(
        tab: _tab,
        name: _name.text,
        email: _email.text,
        password: _password.text,
        rememberMe: _rememberMe,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(_controller.homeRoute);
    } on AppFailure catch (failure) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _onGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Masuk dengan Google belum terhubung.')),
    );
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
        resizeToAvoidBottomInset: true,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AuthColors.headerTop,
                AuthColors.headerMid,
                AuthColors.headerBottom,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Breakpoints.compact),
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: InkWell(
                            key: const Key('auth_back'),
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
                    ),
                  ),
                  Expanded(
                    child: SlideTransition(
                      position: _cardSlide,
                      child: _AuthSheet(
                        tab: _tab,
                        formKey: _formKey,
                        nameController: _name,
                        emailController: _email,
                        passwordController: _password,
                        obscurePassword: _obscurePassword,
                        rememberMe: _rememberMe,
                        submitting: _submitting,
                        onTabChanged: (tab) => setState(() => _tab = tab),
                        onToggleObscure: () {
                          setState(() => _obscurePassword = !_obscurePassword);
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
                        validatorPassword: _controller.validatePassword,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthSheet extends StatelessWidget {
  const _AuthSheet({
    required this.tab,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.submitting,
    required this.onTabChanged,
    required this.onToggleObscure,
    required this.onRememberChanged,
    required this.onForgotPassword,
    required this.onSubmit,
    required this.onGoogle,
    required this.validatorName,
    required this.validatorEmail,
    required this.validatorPassword,
  });

  final AuthTab tab;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final bool submitting;
  final ValueChanged<AuthTab> onTabChanged;
  final VoidCallback onToggleObscure;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;
  final VoidCallback onGoogle;
  final String? Function(String) validatorName;
  final String? Function(String) validatorEmail;
  final String? Function(String) validatorPassword;

  @override
  Widget build(BuildContext context) {
    final isLogin = tab == AuthTab.login;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isShortScreen = constraints.maxHeight < 620;
        final sheetTop = isShortScreen
            ? (isLogin ? 140.0 : 100.0)
            : (isLogin ? 280.0 : 230.0);
        final elephantWidth = (constraints.maxWidth * 0.76).clamp(260.0, 312.0);
        final elephantHeight = elephantWidth * 1.5;
        final elephantContentBottom = elephantHeight * (1089 / 1536);
        final elephantTop = sheetTop - (elephantContentBottom - 26.0);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(top: sheetTop),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Form(
                  key: formKey,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    children: [
                      _AuthTabs(tab: tab, onChanged: onTabChanged),
                      const SizedBox(height: 18),
                      if (!isLogin) ...[
                        AuthTextField(
                          key: const Key('auth_name'),
                          label: 'Nama',
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) => validatorName(value ?? ''),
                        ),
                        const SizedBox(height: 14),
                      ],
                      AuthTextField(
                        key: const Key('auth_email'),
                        label: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validatorEmail(value ?? ''),
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        key: const Key('auth_password'),
                        label: 'Password',
                        controller: passwordController,
                        obscureText: obscurePassword,
                        validator: (value) => validatorPassword(value ?? ''),
                        suffix: IconButton(
                          key: const Key('auth_toggle_password'),
                          onPressed: onToggleObscure,
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AuthColors.muted,
                          ),
                        ),
                      ),
                      if (isLogin) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                key: const Key('auth_remember'),
                                value: rememberMe,
                                onChanged: (value) {
                                  onRememberChanged(value ?? false);
                                },
                                side: const BorderSide(color: AuthColors.muted),
                                activeColor: AuthColors.accent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Ingat saya',
                                style: TextStyle(
                                  color: AuthColors.title,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              key: const Key('auth_forgot'),
                              onPressed: onForgotPassword,
                              style: TextButton.styleFrom(
                                foregroundColor: AuthColors.accent,
                                minimumSize: const Size(48, 40),
                              ),
                              child: const Text('Lupa Sandi?'),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 54,
                        child: FilledButton(
                          key: const Key('auth_submit'),
                          onPressed: submitting ? null : onSubmit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AuthColors.accent,
                            disabledBackgroundColor: AuthColors.accent
                                .withValues(
                                  alpha: 0.6,
                                ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(isLogin ? 'Masuk' : 'Daftar'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(color: AuthColors.fieldBorder),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Atau',
                              style: TextStyle(color: AuthColors.muted),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: AuthColors.fieldBorder),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          key: const Key('auth_google'),
                          onPressed: onGoogle,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AuthColors.title,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            side: const BorderSide(
                              color: AuthColors.fieldBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _GoogleMark(),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Continue with Google',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: elephantTop,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: AuthElephant(width: elephantWidth),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuthTabs extends StatelessWidget {
  const _AuthTabs({required this.tab, required this.onChanged});

  final AuthTab tab;
  final ValueChanged<AuthTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuthColors.tabTrack,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabChip(
              key: const Key('auth_tab_login'),
              label: 'Masuk',
              selected: tab == AuthTab.login,
              onTap: () => onChanged(AuthTab.login),
            ),
            _TabChip(
              key: const Key('auth_tab_register'),
              label: 'Daftar',
              selected: tab == AuthTab.register,
              onTap: () => onChanged(AuthTab.register),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        elevation: selected ? 1.2 : 0,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 42,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? AuthColors.title : AuthColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4285F4),
            height: 1,
          ),
        ),
      ),
    );
  }
}
