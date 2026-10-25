import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.userName = 'Arka',
    this.userLevelTitle = 'Pelukis Cilik • Level 3',
    this.userLevelProgress = 0.6,
    this.remainingStarsText = '2 bintang lagi jadi Pelukis Hebat!',
    this.totalDrawings = 4,
    this.totalStars = 8,
    this.streakDays = 3,
    this.isEmbedded = false,
  });

  final String userName;
  final String userLevelTitle;
  final double userLevelProgress;
  final String remainingStarsText;
  final int totalDrawings;
  final int totalStars;
  final int streakDays;
  final bool isEmbedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;

  void _onToggleSound(bool value) {
    setState(() {
      _isSoundEnabled = value;
    });
  }

  void _onToggleMusic(bool value) {
    setState(() {
      _isMusicEnabled = value;
    });
  }

  void _onOpenClassroomCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur Kode Ruang Kelas segera hadir!')),
    );
  }

  void _onOpenHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pusat Bantuan Curator')),
    );
  }

  void _onLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Keluar Akun?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
            ),
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun ini?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B558B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E5E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F6FF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FF),
        bottomNavigationBar: widget.isEmbedded ? null : _buildStandaloneBottomNav(context),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Lilac Top Header & User Profile Card
                _buildLilacHeader(context),
                const SizedBox(height: 18),

                // 2. Three Stat Cards (Gambar, Bintang, Hari beruntun)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildStatsRow(),
                ),
                const SizedBox(height: 24),

                // 3. Section Title: 'Pengaturan'
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1B4B),
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Settings List (Suara, Musik, Kode Ruang Kelas, Bantuan)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSettingsList(),
                ),
                const SizedBox(height: 20),

                // 5. Logout Button ('Keluar Akun')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildLogoutButton(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLilacHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE7E4FB),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              const Text(
                'Profilku',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // User Info Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular Avatar with white frame ring & pencil edit badge
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      children: [
                        // Avatar image inside white border ring
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A43309A),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                AssetPaths.userAvatarLarge,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        // Pencil Edit Button
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            key: const Key('profile_edit_avatar_button'),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur ubah foto profil segera hadir!'),
                                ),
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C42F5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3343309A),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.edit_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // User Detail, Level Pill & Progress Bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1B4B),
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Level badge
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xFFFFB800),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.userLevelTitle,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF6D3FE0),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Level Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: widget.userLevelProgress,
                            minHeight: 7,
                            backgroundColor: const Color(0xFFDCD7F6),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF6C42F5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Progress hint
                        Text(
                          widget.remainingStarsText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C719C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        // 1. Gambar
        Expanded(
          child: _buildStatCard(
            key: const Key('profile_stat_drawings'),
            icon: Icons.palette_rounded,
            iconBgColor: const Color(0xFFE2FBEA),
            iconColor: const Color(0xFF10BD8A),
            value: '${widget.totalDrawings}',
            label: 'Gambar',
          ),
        ),
        const SizedBox(width: 12),

        // 2. Bintang
        Expanded(
          child: _buildStatCard(
            key: const Key('profile_stat_stars'),
            icon: Icons.star_rounded,
            iconBgColor: const Color(0xFFFFF6D6),
            iconColor: const Color(0xFFFFB800),
            value: '${widget.totalStars}',
            label: 'Bintang',
          ),
        ),
        const SizedBox(width: 12),

        // 3. Hari beruntun
        Expanded(
          child: _buildStatCard(
            key: const Key('profile_stat_streak'),
            icon: Icons.local_fire_department_rounded,
            iconBgColor: const Color(0xFFFFEBE5),
            iconColor: const Color(0xFFFF6B4A),
            value: '${widget.streakDays}',
            label: 'Hari\nberuntun',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required Key key,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEEF8), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A43309A),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Box
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 2),

          // Label
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7C719C),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      children: [
        // 1. Suara
        _buildSettingCard(
          icon: Icons.volume_up_rounded,
          iconBgColor: const Color(0xFFE2FBEA),
          iconColor: const Color(0xFF10BD8A),
          title: 'Suara',
          trailing: _buildCustomSwitch(
            key: const Key('profile_switch_sound'),
            value: _isSoundEnabled,
            onChanged: _onToggleSound,
          ),
        ),
        const SizedBox(height: 12),

        // 2. Musik
        _buildSettingCard(
          icon: Icons.music_note_rounded,
          iconBgColor: const Color(0xFFEBE6FC),
          iconColor: const Color(0xFF6D3FE0),
          title: 'Musik',
          trailing: _buildCustomSwitch(
            key: const Key('profile_switch_music'),
            value: _isMusicEnabled,
            onChanged: _onToggleMusic,
          ),
        ),
        const SizedBox(height: 12),

        // 3. Kode Ruang Kelas
        _buildSettingCard(
          icon: Icons.school_rounded,
          iconBgColor: const Color(0xFFFFF4D6),
          iconColor: const Color(0xFFF59E0B),
          title: 'Kode Ruang Kelas',
          onTap: _onOpenClassroomCode,
          trailing: _buildChevronButton(),
        ),
        const SizedBox(height: 12),

        // 4. Bantuan
        _buildSettingCard(
          icon: Icons.help_outline_rounded,
          iconBgColor: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0284C7),
          title: 'Bantuan',
          onTap: _onOpenHelp,
          trailing: _buildChevronButton(),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFECEEF8), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A43309A),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Leading Icon Container
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
              ),

              // Trailing Widget (Switch / Chevron)
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required Key key,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      key: key,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF6C42F5) : const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChevronButton() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F5FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Color(0xFF6D3FE0),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        key: const Key('profile_logout_button'),
        onPressed: _onLogout,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF5E5E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.white,
            ),
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

  Widget _buildStandaloneBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4DFF).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.home),
                icon: const Icon(Icons.home_rounded, color: Color(0xFF6D3FE0), size: 28),
              ),
              // 2. History
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.history),
                icon: const Icon(Icons.history_rounded, color: Color(0xFF6D3FE0), size: 28),
              ),
              // 3. Profile Pill
              Container(
                width: 74,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6D3FE0),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x336D3FE0),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
