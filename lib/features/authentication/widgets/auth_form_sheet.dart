import 'package:flutter/material.dart';

import '../models/auth_tab.dart';
import '../widgets/auth_colors.dart';
import '../widgets/auth_elephant.dart';
import '../widgets/auth_scroll_view.dart';
import '../widgets/auth_tabs.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_logo.dart';

class AuthFormSheet extends StatelessWidget {
  const AuthFormSheet({
    super.key,
    required this.tab,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.rememberMe,
    required this.submitting,
    required this.onTabChanged,
    required this.onToggleObscure,
    required this.onToggleObscureConfirm,
    required this.onRememberChanged,
    required this.onForgotPassword,
    required this.onSubmit,
    required this.onGoogle,
    required this.validatorName,
    required this.validatorEmail,
    required this.validatorPassword,
    required this.validatorConfirmPassword,
  });

  final AuthTab tab;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool rememberMe;
  final bool submitting;
  final ValueChanged<AuthTab> onTabChanged;
  final VoidCallback onToggleObscure;
  final VoidCallback onToggleObscureConfirm;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;
  final VoidCallback onGoogle;
  final String? Function(String) validatorName;
  final String? Function(String) validatorEmail;
  final String? Function(String) validatorPassword;
  final String? Function(String) validatorConfirmPassword;

  @override
  Widget build(BuildContext context) {
    final isLogin = tab == AuthTab.login;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isShortScreen = constraints.maxHeight < 620;
        final sheetTop = isShortScreen
            ? (isLogin ? 124.0 : 84.0)
            : (isLogin ? 268.0 : 198.0);
        final elephantWidth = (constraints.maxWidth * 0.78).clamp(260.0, 320.0);
        final elephantHeight = elephantWidth * 1.5;
        final elephantContentBottom = elephantHeight * (1089 / 1536);
        final elephantTop = sheetTop - (elephantContentBottom - 27.0);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPadding(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(top: sheetTop),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(
                      color: AuthColors.cardShadow,
                      blurRadius: 28,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: Form(
                      key: formKey,
                      child: AuthScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                        children: [
                          AuthTabs(tab: tab, onChanged: onTabChanged),
                          const SizedBox(height: 20),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 360),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              final offset = Tween<Offset>(
                                begin: const Offset(0, 0.04),
                                end: Offset.zero,
                              ).animate(animation);
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offset,
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              key: ValueKey(tab),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (!isLogin) ...[
                                  AuthTextField(
                                    key: const Key('auth_name'),
                                    label: 'Nama',
                                    requiredMark: true,
                                    hintText: 'Masukkan nama lengkap',
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    prefix: const _FieldIcon(
                                      Icons.person_outline_rounded,
                                    ),
                                    validator: (value) =>
                                        validatorName(value ?? ''),
                                  ),
                                  const SizedBox(height: 14),
                                ],
                                AuthTextField(
                                  key: const Key('auth_email'),
                                  label: 'Email',
                                  requiredMark: !isLogin,
                                  hintText: 'Masukkan email kamu',
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefix: const _FieldIcon(
                                    Icons.mail_outline_rounded,
                                  ),
                                  validator: (value) =>
                                      validatorEmail(value ?? ''),
                                ),
                                const SizedBox(height: 14),
                                AuthTextField(
                                  key: const Key('auth_password'),
                                  label: 'Password',
                                  requiredMark: !isLogin,
                                  hintText: isLogin
                                      ? 'Masukkan password'
                                      : 'Minimal 8 karakter',
                                  controller: passwordController,
                                  obscureText: obscurePassword,
                                  prefix: const _FieldIcon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  validator: (value) =>
                                      validatorPassword(value ?? ''),
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
                                if (!isLogin) ...[
                                  const SizedBox(height: 14),
                                  AuthTextField(
                                    key: const Key('auth_confirm_password'),
                                    label: 'Konfirmasi Password',
                                    requiredMark: true,
                                    hintText: 'Ulangi password',
                                    controller: confirmPasswordController,
                                    obscureText: obscureConfirmPassword,
                                    prefix: const _FieldIcon(
                                      Icons.lock_outline_rounded,
                                    ),
                                    validator: (value) =>
                                        validatorConfirmPassword(value ?? ''),
                                    suffix: IconButton(
                                      key: const Key(
                                        'auth_toggle_confirm_password',
                                      ),
                                      onPressed: onToggleObscureConfirm,
                                      icon: Icon(
                                        obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AuthColors.muted,
                                      ),
                                    ),
                                  ),
                                ],
                                if (isLogin) ...[
                                  const SizedBox(height: 8),
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          side: const BorderSide(
                                            color: AuthColors.muted,
                                          ),
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
                                        child: const Text(
                                          'Lupa Sandi?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 16),
                                AuthPrimaryButton(
                                  key: const Key('auth_submit'),
                                  label: isLogin ? 'Masuk' : 'Daftar',
                                  submitting: submitting,
                                  onPressed: onSubmit,
                                ),
                                const SizedBox(height: 16),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AuthColors.fieldBorder,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        'Atau',
                                        style: TextStyle(
                                          color: AuthColors.muted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AuthColors.fieldBorder,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 52,
                                  child: OutlinedButton(
                                    key: const Key('auth_google'),
                                    onPressed: onGoogle,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AuthColors.title,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      side: const BorderSide(
                                        color: AuthColors.fieldBorder,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GoogleLogo(),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutCubic,
              top: elephantTop,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(child: AuthElephant(width: elephantWidth)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FieldIcon extends StatelessWidget {
  const _FieldIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 18, color: AuthColors.muted);
  }
}
