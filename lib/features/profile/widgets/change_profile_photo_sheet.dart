import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../models/profile_avatar_option.dart';
import '../models/profile_photo.dart';
import '../services/profile_photo_service.dart';
import 'circle_photo_cropper.dart';

const _deepPurple = Color(0xFF2B2160);
const _primaryPurple = Color(0xFF6D3FE0);
const _mutedPurple = Color(0xFF7C7096);
const _softLavender = Color(0xFFF1ECFF);

/// Menampilkan popup Ganti Foto Profil.
///
/// - Layar < 600px: bottom sheet dari bawah.
/// - Layar >= 600px: modal di tengah layar.
Future<ProfilePhoto?> showChangeProfilePhotoSheet(
  BuildContext context, {
  required ProfilePhotoService service,
  String? currentAssetPath,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= Breakpoints.compact) {
    return showDialog<ProfilePhoto>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ChangeProfilePhotoSheet(
            service: service,
            asDialog: true,
            currentAssetPath: currentAssetPath,
          ),
        ),
      ),
    );
  }

  return showModalBottomSheet<ProfilePhoto>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.42),
    builder: (_) => ChangeProfilePhotoSheet(
      service: service,
      currentAssetPath: currentAssetPath,
    ),
  );
}

enum _SheetStep { options, crop, avatar }

class ChangeProfilePhotoSheet extends StatefulWidget {
  const ChangeProfilePhotoSheet({
    super.key,
    required this.service,
    this.asDialog = false,
    this.currentAssetPath,
  });

  final ProfilePhotoService service;
  final bool asDialog;

  /// Avatar yang sedang dipakai, untuk menentukan state "belum ada perubahan".
  final String? currentAssetPath;

  @override
  State<ChangeProfilePhotoSheet> createState() =>
      _ChangeProfilePhotoSheetState();
}

class _ChangeProfilePhotoSheetState extends State<ChangeProfilePhotoSheet> {
  final GlobalKey<CirclePhotoCropperState> _cropperKey = GlobalKey();

  _SheetStep _step = _SheetStep.options;
  Uint8List? _pickedBytes;
  String? _selectedAvatar;
  String? _avatarBaseline;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final current = widget.currentAssetPath;
    final isKnownAvatar =
        current != null &&
        ProfileAvatarOption.builtIn.any(
          (option) => option.assetPath == current,
        );
    _selectedAvatar = isKnownAvatar
        ? current
        : ProfileAvatarOption.builtIn.first.assetPath;
    _avatarBaseline = current;
  }

  /// Simpan hanya aktif kalau pilihan avatar berubah.
  bool get _canSaveAvatar =>
      !_saving && _selectedAvatar != null && _selectedAvatar != _avatarBaseline;

  Future<void> _pickFromCamera() => _pick(widget.service.pickFromCamera);

  Future<void> _pickFromGallery() => _pick(widget.service.pickFromGallery);

  Future<void> _pick(Future<Uint8List?> Function() picker) async {
    try {
      final bytes = await picker();
      if (!mounted || bytes == null) return;
      setState(() {
        _pickedBytes = bytes;
        _step = _SheetStep.crop;
      });
    } on AppFailure catch (failure) {
      _showError(failure.message);
    } on Object {
      _showError('Tidak bisa membuka kamera/galeri. Coba lagi.');
    }
  }

  void _openAvatarPicker() {
    setState(() => _step = _SheetStep.avatar);
  }

  void _backToOptions() {
    setState(() {
      _step = _SheetStep.options;
      _pickedBytes = null;
    });
  }

  Future<void> _saveCroppedPhoto() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final bytes = await _cropperKey.currentState?.capture();
      if (bytes == null) {
        throw const AppFailure(message: 'Gagal memproses foto. Coba lagi.');
      }
      final photo = await widget.service.saveCustomPhoto(bytes);
      if (!mounted) return;
      Navigator.of(context).pop(photo);
    } on AppFailure catch (failure) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showError(failure.message);
    } on Object {
      if (!mounted) return;
      setState(() => _saving = false);
      _showError('Foto gagal disimpan. Coba lagi.');
    }
  }

  Future<void> _saveAvatar() async {
    final assetPath = _selectedAvatar;
    if (assetPath == null || !_canSaveAvatar) return;
    setState(() => _saving = true);
    try {
      final photo = await widget.service.saveBuiltInAvatar(assetPath);
      if (!mounted) return;
      Navigator.of(context).pop(photo);
    } on AppFailure catch (failure) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showError(failure.message);
    } on Object {
      if (!mounted) return;
      setState(() => _saving = false);
      _showError('Avatar gagal disimpan. Coba lagi.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFFF5E5E),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxHeight = screenHeight * (widget.asDialog ? 0.86 : 0.94);

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF8F4FF)],
        ),
        borderRadius: widget.asDialog
            ? BorderRadius.circular(36)
            : const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332B2160),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, widget.asDialog ? 24 : 10, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.asDialog) const _DragHandle(),
              if (!widget.asDialog) const SizedBox(height: 6),
              _buildHeader(),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: switch (_step) {
                  _SheetStep.options => _buildOptions(),
                  _SheetStep.crop => _buildCropStep(),
                  _SheetStep.avatar => _buildAvatarStep(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isOptions = _step == _SheetStep.options;
    final title = switch (_step) {
      _SheetStep.options => 'Ganti Foto Profil',
      _SheetStep.crop => 'Atur Foto Profil',
      _SheetStep.avatar => 'Pilih Avatar',
    };
    final subtitle = switch (_step) {
      _SheetStep.options => 'Yuk, pilih foto terbaik untuk profilmu!',
      _SheetStep.crop => null,
      _SheetStep.avatar => 'Pilih karakter favoritmu!',
    };
    final showStars = _step == _SheetStep.avatar;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: isOptions
                  ? const Padding(
                      padding: EdgeInsets.only(left: 2, top: 6),
                      child: _Sparkles(),
                    )
                  : _CircleIconButton(
                      key: const Key('change_photo_back_button'),
                      icon: Icons.chevron_left_rounded,
                      onTap: _backToOptions,
                    ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: _deepPurple,
                  letterSpacing: -0.6,
                  height: 1.15,
                ),
              ),
            ),
            _CircleIconButton(
              key: const Key('change_photo_close_button'),
              icon: Icons.close_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showStars) ...[
                const Icon(
                  Icons.star_rounded,
                  size: 15,
                  color: Color(0xFFFFC93C),
                ),
                const SizedBox(width: 7),
              ],
              Flexible(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: _mutedPurple,
                    height: 1.35,
                  ),
                ),
              ),
              if (showStars) ...[
                const SizedBox(width: 7),
                const Icon(
                  Icons.star_rounded,
                  size: 15,
                  color: Color(0xFFFFC93C),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      key: const ValueKey('change_photo_options'),
      children: [
        _OptionCards(
          onCamera: _pickFromCamera,
          onGallery: _pickFromGallery,
          onAvatar: _openAvatarPicker,
        ),
        const SizedBox(height: 22),
        _SheetButton(
          key: const Key('change_photo_cancel_button'),
          label: 'Batal',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildCropStep() {
    final bytes = _pickedBytes;
    if (bytes == null) {
      // Pengaman bila state tidak sinkron.
      WidgetsBinding.instance.addPostFrameCallback((_) => _backToOptions());
      return const SizedBox.shrink();
    }

    return Column(
      key: const ValueKey('change_photo_crop'),
      children: [
        const SizedBox(height: 4),
        CirclePhotoCropper(key: _cropperKey, imageBytes: bytes),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pinch_rounded, size: 18, color: _primaryPurple),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Cubit untuk zoom, geser untuk mengatur posisi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _mutedPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _SheetButton(
                key: const Key('change_photo_crop_cancel_button'),
                label: 'Batal',
                onTap: _saving ? null : _backToOptions,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SheetButton(
                key: const Key('change_photo_save_button'),
                label: 'Simpan Foto',
                primary: true,
                loading: _saving,
                onTap: _saveCroppedPhoto,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarStep() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final columns = _avatarColumns(screenWidth);

    return Column(
      key: const ValueKey('change_photo_avatar'),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 12.0;
            final tileSize =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            final rows = (ProfileAvatarOption.builtIn.length / columns).ceil();
            final naturalHeight = rows * tileSize + (rows - 1) * gap;
            final maxHeight = screenHeight * 0.44;
            final scrollable = naturalHeight > maxHeight;

            return SizedBox(
              height: scrollable ? maxHeight : naturalHeight,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: scrollable
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: ProfileAvatarOption.builtIn.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: gap,
                  crossAxisSpacing: gap,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final option = ProfileAvatarOption.builtIn[index];
                  return _AvatarTile(
                    key: Key('avatar_option_$index'),
                    option: option,
                    selected: option.assetPath == _selectedAvatar,
                    onTap: _saving
                        ? null
                        : () => setState(
                            () => _selectedAvatar = option.assetPath,
                          ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _SheetButton(
                key: const Key('change_photo_avatar_cancel_button'),
                label: 'Batal',
                onTap: _saving ? null : _backToOptions,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _SheetButton(
                key: const Key('change_photo_avatar_save_button'),
                label: 'Simpan Avatar',
                primary: true,
                loading: _saving,
                onTap: _canSaveAvatar ? _saveAvatar : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Desktop 5 kolom, tablet 4, mobile 3, layar sangat sempit 2.
  int _avatarColumns(double screenWidth) {
    if (screenWidth >= Breakpoints.medium) return 5;
    if (screenWidth >= Breakpoints.compact) return 4;
    if (screenWidth >= 340) return 3;
    return 2;
  }
}

class _OptionCards extends StatelessWidget {
  const _OptionCards({
    required this.onCamera,
    required this.onGallery,
    required this.onAvatar,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onAvatar;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final cardWidth = (constraints.maxWidth - gap * 2) / 3;
        final canFitRow = cardWidth >= 104;

        final cards = [
          _PhotoOptionCard(
            key: const Key('change_photo_camera_card'),
            imagePath: AssetPaths.cameraIcon,
            title: 'Ambil Foto',
            description: 'Gunakan kamera perangkat',
            background: const Color(0xFFE9FBF2),
            onTap: onCamera,
          ),
          _PhotoOptionCard(
            key: const Key('change_photo_gallery_card'),
            imagePath: AssetPaths.galleryIcon,
            title: 'Pilih dari Galeri',
            description: 'Pilih foto yang tersimpan',
            background: const Color(0xFFEFE9FF),
            onTap: onGallery,
          ),
          _PhotoOptionCard(
            key: const Key('change_photo_avatar_card'),
            imagePath: AssetPaths.mascotAvatar,
            title: 'Pilih Avatar',
            description: 'Gunakan avatar SKETCHOO',
            background: const Color(0xFFFFF5DD),
            onTap: onAvatar,
          ),
        ];

        if (canFitRow) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: gap),
                  Expanded(child: cards[i]),
                ],
              ],
            ),
          );
        }

        return SizedBox(
          height: 218,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, _) => const SizedBox(width: gap),
            itemBuilder: (_, index) =>
                SizedBox(width: 152, child: cards[index]),
          ),
        );
      },
    );
  }
}

class _PhotoOptionCard extends StatelessWidget {
  const _PhotoOptionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.background,
    required this.onTap,
  });

  final String imagePath;
  final String title;
  final String description;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F0A2E),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: background,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xE6FFFFFF), width: 1.2),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 72,
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: _deepPurple,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _mutedPurple,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarTile extends StatelessWidget {
  const _AvatarTile({
    super.key,
    required this.option,
    required this.selected,
    this.onTap,
  });

  final ProfileAvatarOption option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      child: AnimatedScale(
        scale: selected ? 1 : 0.97,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: option.background,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? _primaryPurple : const Color(0xF2FFFFFF),
              width: selected ? 3 : 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? const Color(0x4D6D3FE0)
                    : const Color(0x140F0A2E),
                blurRadius: selected ? 18 : 10,
                offset: Offset(0, selected ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(selected ? 19 : 20.6),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // object-fit: contain agar seluruh karakter terlihat,
                // dibungkus clip sendiri supaya sudut gambar ikut rounded.
                Padding(
                  padding: EdgeInsets.all(selected ? 5 : 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      option.assetPath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.pets_rounded,
                        color: _primaryPurple,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: AnimatedScale(
                    scale: selected ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF9B7BFF), Color(0xFF6D3FE0)],
                        ),
                        border: Border.all(color: Colors.white, width: 1.6),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x406D3FE0),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !loading;
    final textColor = primary ? Colors.white : _primaryPurple;

    final child = Center(
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
    );

    return SizedBox(
      height: 54,
      child: primary
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: enabled
                      ? const [Color(0xFF9B7BFF), Color(0xFF6D3FE0)]
                      : const [Color(0xFFC9BCF7), Color(0xFFB3A2EC)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x338B74FF),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? onTap : null,
                  borderRadius: BorderRadius.circular(28),
                  child: child,
                ),
              ),
            )
          : Material(
              color: _softLavender,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(28),
                child: child,
              ),
            ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFF3EFFE),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: _deepPurple),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFFDDD6FE),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Sparkles extends StatelessWidget {
  const _Sparkles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(left: 0, top: 22, child: _dash(20, 6, -0.55)),
        Positioned(left: 14, top: 10, child: _dash(17, 6, -0.25)),
        Positioned(left: 26, top: 3, child: _dash(13, 6, 0.05)),
      ],
    );
  }

  Widget _dash(double width, double height, double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD43B),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
