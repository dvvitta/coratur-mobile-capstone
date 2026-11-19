import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_failure.dart';
import '../models/profile_photo.dart';
import '../services/profile_photo_service.dart';
import '../widgets/change_profile_photo_sheet.dart';
import '../widgets/classroom_code_sheet.dart';
import '../widgets/profile_joined_classroom_card.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_setting_card.dart';
import '../widgets/profile_stats_row.dart';
import '../../home/widgets/home_background.dart';
import '../../../core/widgets/curator_bottom_nav.dart';

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
    this.totalBadges,
    this.isEmbedded = false,
    this.onLogout,
    this.profilePhotoService,
    this.onJoinClassroom,
    this.profilePhoto,
    this.onProfilePhotoChanged,
  });

  final String userName;
  final String? userLevelTitle;
  final double? userLevelProgress;
  final String? remainingStarsText;
  final int? totalDrawings;
  final int? totalStars;
  final int? streakDays;
  final int? totalBadges;
  final bool isEmbedded;

  /// Dipanggil saat pengguna keluar, untuk membersihkan sesi (token) di memori.
  final VoidCallback? onLogout;

  /// Dapat di-inject pada test; default memakai penyimpanan lokal.
  final ProfilePhotoService? profilePhotoService;

  /// Callback remote untuk menghubungkan siswa ke kelas dengan kode 6 karakter.
  final Future<Map<String, String>?> Function(String code)? onJoinClassroom;

  /// Foto profil aktif yang disinkronkan dengan Home dan Session.
  final ProfilePhoto? profilePhoto;

  /// Notifikasi saat foto profil berhasil diubah.
  final ValueChanged<ProfilePhoto>? onProfilePhotoChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  String? _joinedClassName;
  String? _joinedTeacherName;
  late final ProfilePhotoService _photoService;
  ProfilePhoto? _profilePhoto;

  @override
  void initState() {
    super.initState();
    _photoService = widget.profilePhotoService ?? ProfilePhotoService();
    _profilePhoto = widget.profilePhoto;
    if (_profilePhoto == null) {
      _loadProfilePhoto();
    }
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profilePhoto != null &&
        widget.profilePhoto != oldWidget.profilePhoto) {
      _profilePhoto = widget.profilePhoto;
    }
  }

  Future<void> _loadProfilePhoto() async {
    final photo = await _photoService.load();
    if (!mounted || photo == null) return;
    setState(() => _profilePhoto = photo);
  }

  Future<void> _onChangeProfilePhoto() async {
    final currentPhoto = _profilePhoto;
    final photo = await showChangeProfilePhotoSheet(
      context,
      service: _photoService,
      // Foto custom tidak punya assetPath; default memakai avatar fallback.
      currentAssetPath: currentPhoto != null && currentPhoto.isCustom
          ? null
          : currentPhoto?.assetPath ?? ProfilePhoto.fallback.assetPath,
    );
    if (!mounted || photo == null) return;
    setState(() => _profilePhoto = photo);
    widget.onProfilePhotoChanged?.call(photo);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diperbarui'),
          backgroundColor: Color(0xFF6C42F5),
        ),
      );
  }

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
  int get _badges => widget.totalBadges ?? (_isDefaultMock ? 1 : 0);

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
      builder: (_) => const ClassroomCodeSheet(),
    );

    if (result != null && mounted) {
      if (widget.onJoinClassroom != null) {
        try {
          final res = await widget.onJoinClassroom!(result);
          if (!mounted) return;
          if (res != null) {
            setState(() {
              _joinedClassName = res['className'] ?? 'Kelas';
              _joinedTeacherName = res['teacherName'] ?? 'Guru Kelas';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Terhubung ke $_joinedClassName'),
                backgroundColor: const Color(0xFF6C42F5),
              ),
            );
          }
        } on AppFailure catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              backgroundColor: const Color(0xFFE53935),
            ),
          );
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghubungkan ke kelas. Coba lagi.'),
              backgroundColor: Color(0xFFE53935),
            ),
          );
        }
      } else {
        // ponytail: fallback lokal saat tidak ada remote handler yang diinjeksi.
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
  }

  void _onOpenHelp() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pusat Bantuan Curator')));
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
            style: TextStyle(fontSize: 14, color: Color(0xFF6B558B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.onLogout?.call();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
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
        systemNavigationBarColor: HomeBackground.baseColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: HomeBackground.baseColor,
        extendBody: !widget.isEmbedded,
        bottomNavigationBar: widget.isEmbedded
            ? null
            : CuratorBottomNav(
                selectedIndex: 2,
                onDestinationSelected: (index) {
                  if (index == 0) {
                    Navigator.of(context).pushNamed(AppRoutes.home);
                  }
                  if (index == 1) {
                    Navigator.of(context).pushNamed(AppRoutes.history);
                  }
                },
              ),
        body: HomeBackground(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              primary: true,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: const Text(
                      'Profilku',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF30216D),
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProfileInfoCard(
                      userName: widget.userName,
                      levelTitle: _levelTitle,
                      levelProgress: _levelProgress,
                      remainingText: _remainingText,
                      photo: _profilePhoto,
                      onEditAvatar: _onChangeProfilePhoto,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProfileStatsRow(
                      drawings: _drawings,
                      stars: _stars,
                      badges: _badges,
                      onBadgesTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.badges);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ProfileSettingCard(
                          icon: Icons.volume_up_rounded,
                          iconBgColor: const Color(0xFFE2FBEA),
                          iconColor: const Color(0xFF10BD8A),
                          title: 'Suara',
                          trailing: ProfileCustomSwitch(
                            key: const Key('profile_switch_sound'),
                            value: _isSoundEnabled,
                            onChanged: _onToggleSound,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileSettingCard(
                          icon: Icons.music_note_rounded,
                          iconBgColor: const Color(0xFFEBE6FC),
                          iconColor: const Color(0xFF6D3FE0),
                          title: 'Musik',
                          trailing: ProfileCustomSwitch(
                            key: const Key('profile_switch_music'),
                            value: _isMusicEnabled,
                            onChanged: _onToggleMusic,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_joinedClassName != null)
                          ProfileJoinedClassroomCard(
                            className: _joinedClassName!,
                            teacherName: _joinedTeacherName ?? 'Guru: Bu Asri',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Detail $_joinedClassName ($_joinedTeacherName)',
                                  ),
                                  backgroundColor: const Color(0xFF6C42F5),
                                ),
                              );
                            },
                          )
                        else
                          ProfileSettingCard(
                            icon: Icons.school_rounded,
                            iconBgColor: const Color(0xFFFFF4D6),
                            iconColor: const Color(0xFFF59E0B),
                            title: 'Kode Ruang Kelas',
                            onTap: _onOpenClassroomCode,
                            trailing: const ProfileChevronButton(),
                          ),
                        const SizedBox(height: 12),
                        ProfileSettingCard(
                          icon: Icons.help_outline_rounded,
                          iconBgColor: const Color(0xFFE0F2FE),
                          iconColor: const Color(0xFF0284C7),
                          title: 'Bantuan',
                          onTap: _onOpenHelp,
                          trailing: const ProfileChevronButton(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProfileLogoutButton(onTap: _onLogout),
                  ),
                  SizedBox(height: widget.isEmbedded ? 112 : 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
