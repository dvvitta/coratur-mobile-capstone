import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.userName = 'Arka',
    this.userLevelTitle,
    this.userLevelProgress,
    this.remainingStarsText,
    this.totalDrawings,
    this.totalStars,
    this.streakDays,
    this.isEmbedded = false,
  });

  final String userName;
  final String? userLevelTitle;
  final double? userLevelProgress;
  final String? remainingStarsText;
  final int? totalDrawings;
  final int? totalStars;
  final int? streakDays;
  final bool isEmbedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  String? _joinedClassName;
  String? _joinedTeacherName;

  bool get _isDefaultMock => widget.userName == 'Arka';

  String get _levelTitle =>
      widget.userLevelTitle ??
      (_isDefaultMock ? 'Pelukis Cilik • Level 3' : 'Pelukis Pemula • Level 1');

  double get _levelProgress =>
      widget.userLevelProgress ?? (_isDefaultMock ? 0.6 : 0.0);

  String get _remainingText =>
      widget.remainingStarsText ??
      (_isDefaultMock
          ? '2 bintang lagi jadi Pelukis Hebat!'
          : 'Kumpulkan 5 bintang untuk naik level!');

  int get _drawings => widget.totalDrawings ?? (_isDefaultMock ? 4 : 0);
  int get _stars => widget.totalStars ?? (_isDefaultMock ? 8 : 0);
  int get _streak => widget.streakDays ?? (_isDefaultMock ? 3 : 1);

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

  Future<void> _onOpenClassroomCode() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => const _ClassroomCodeSheet(),
    );

    if (result != null && mounted) {
      setState(() {
        _joinedClassName = 'Kelas 2A';
        _joinedTeacherName = 'Guru: Bu Asri';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terhubung ke $_joinedClassName'),
          backgroundColor: const Color(0xFF6C42F5),
        ),
      );
    }
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
                                _levelTitle,
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
                            value: _levelProgress,
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
                          _remainingText,
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
            value: '$_drawings',
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
            value: '$_stars',
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
            value: '$_streak',
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

        // 3. Kode Ruang Kelas / Kelas Terhubung
        if (_joinedClassName != null)
          _buildJoinedClassroomCard()
        else
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

  Widget _buildJoinedClassroomCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('profile_joined_classroom_card'),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Detail $_joinedClassName ($_joinedTeacherName)'),
              backgroundColor: const Color(0xFF6C42F5),
            ),
          );
        },
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
              // Golden yellow lock container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 24,
                  color: Color(0xFFB45309),
                ),
              ),
              const SizedBox(width: 14),

              // Title and Teacher name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _joinedClassName ?? 'Kelas 2A',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1B4B),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _joinedTeacherName ?? 'Guru: Bu Asri',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A3E6D),
                      ),
                    ),
                  ],
                ),
              ),

              // Green pill badge 'Terhubung'
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Color(0xFF047857),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Terhubung',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),

              // Right chevron
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Color(0xFF7C6E9B),
              ),
            ],
          ),
        ),
      ),
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

// ─── Classroom Code Bottom Sheet ───────────────────────────────────────────

class _ClassroomCodeSheet extends StatefulWidget {
  const _ClassroomCodeSheet();

  @override
  State<_ClassroomCodeSheet> createState() => _ClassroomCodeSheetState();
}

class _ClassroomCodeSheetState extends State<_ClassroomCodeSheet> {
  static const int _codeLength = 6;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isComplete => _controller.text.trim().length == _codeLength;

  void _onJoin() {
    if (!_isComplete) return;
    final code = _controller.text.trim();
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final text = _controller.text;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD6FE),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Header row with close button (X)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('classroom_close_button'),
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3EFFE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF2B1E70),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Yellow Circle with Classroom/People Icon
          Center(
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 34,
                color: Color(0xFFB45309),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            'Masukkan Kode Kelas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          const Text(
            'Minta kode dari gurumu ya!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF736A8C),
            ),
          ),
          const SizedBox(height: 24),

          // 6 PIN Boxes (tap to focus hidden text field)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _focusNode.requestFocus(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Hidden real textfield
                Opacity(
                  opacity: 0,
                  child: TextField(
                    key: const Key('classroom_code_input'),
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: _codeLength,
                    autofocus: true,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                // Visual 6 rounded boxes row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_codeLength, (index) {
                    final isFilled = index < text.length;
                    final isCurrent = index == text.length && _focusNode.hasFocus;
                    final char = isFilled ? text[index] : '';

                    return _buildPinBox(
                      char: char,
                      isFilled: isFilled,
                      isCurrent: isCurrent,
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Disclaimer box with Eye Icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EFFE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 22,
                  color: Color(0xFF6C42F5),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Gurumu bisa melihat gambar dan bintangmu\nuntuk membantu belajarmu.',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4C3B78),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Button 'Gabung Kelas'
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const Key('classroom_join_button'),
              onPressed: _isComplete ? _onJoin : null,
              style: FilledButton.styleFrom(
                backgroundColor: _isComplete
                    ? const Color(0xFF6C42F5)
                    : const Color(0xFFDDD6FE),
                disabledBackgroundColor: const Color(0xFFDDD6FE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Gabung Kelas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _isComplete
                      ? Colors.white
                      : const Color(0xFF7C3AED),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinBox({
    required String char,
    required bool isFilled,
    required bool isCurrent,
  }) {
    // Ukuran box: proporsional tinggi ~62, lebar ~48, rounded 14
    return SizedBox(
      width: 48,
      height: 62,
      child: CustomPaint(
        painter: isFilled || isCurrent
            ? null
            : _DashedBorderPainter(
                color: const Color(0xFFC4B5FD),
                borderRadius: 14,
                strokeWidth: 1.8,
                dashLength: 5,
                gapLength: 3.5,
              ),
        child: Container(
          decoration: BoxDecoration(
            color: isFilled ? const Color(0xFFECE7F9) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isCurrent
                ? Border.all(color: const Color(0xFF6C42F5), width: 2)
                : isFilled
                    ? Border.all(color: const Color(0xFFD4CCE8), width: 1.2)
                    : null,
          ),
          alignment: Alignment.center,
          child: isFilled
              ? Text(
                  char,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B),
                  ),
                )
              : isCurrent
                  ? Container(
                      width: 2,
                      height: 24,
                      color: const Color(0xFF6C42F5),
                    )
                  : null,
        ),
      ),
    );
  }
}

/// Custom painter untuk border putus-putus (dashed rounded rectangle)
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashLength;
        dashedPath.addPath(
          metric.extractPath(distance, nextDistance.clamp(0.0, metric.length)),
          Offset.zero,
        );
        distance += dashLength + gapLength;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderRadius != oldDelegate.borderRadius ||
      strokeWidth != oldDelegate.strokeWidth ||
      dashLength != oldDelegate.dashLength ||
      gapLength != oldDelegate.gapLength;
}
