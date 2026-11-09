import 'package:flutter/material.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        key: const Key('profile_logout_button'),
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF5E5E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Keluar Akun',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
