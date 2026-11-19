import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/features/profile/models/profile_avatar_option.dart';
import 'package:curator/features/profile/screens/profile_screen.dart';
import 'package:curator/features/profile/services/profile_photo_service.dart';
import 'package:curator/features/profile/services/profile_photo_store.dart';

void main() {
  void setScreen(WidgetTester tester, Size size) {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
  }

  testWidgets('popup ganti foto tampil lengkap di layar mobile', (
    tester,
  ) async {
    setScreen(tester, const Size(412, 1055));

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          profilePhotoService: ProfilePhotoService(
            store: InMemoryProfilePhotoStore(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile_edit_avatar_button')));
    await tester.pumpAndSettle();

    expect(find.text('Ganti Foto Profil'), findsOneWidget);
    expect(
      find.text('Yuk, pilih foto terbaik untuk profilmu!'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('change_photo_camera_card')), findsOneWidget);
    expect(find.byKey(const Key('change_photo_gallery_card')), findsOneWidget);
    expect(find.byKey(const Key('change_photo_avatar_card')), findsOneWidget);
    expect(find.byKey(const Key('change_photo_close_button')), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('change_photo_cancel_button')));
    await tester.pumpAndSettle();

    expect(find.text('Ganti Foto Profil'), findsNothing);
  });

  testWidgets('popup tetap aman di layar sempit tanpa overflow', (
    tester,
  ) async {
    setScreen(tester, const Size(320, 640));

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          profilePhotoService: ProfilePhotoService(
            store: InMemoryProfilePhotoStore(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile_edit_avatar_button')));
    await tester.pumpAndSettle();

    expect(find.text('Ganti Foto Profil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pilih avatar lalu simpan memperbarui foto profil', (
    tester,
  ) async {
    setScreen(tester, const Size(412, 1055));
    final store = InMemoryProfilePhotoStore();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          profilePhotoService: ProfilePhotoService(store: store),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile_edit_avatar_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('change_photo_avatar_card')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('avatar_option_1')), findsOneWidget);

    await tester.tap(find.byKey(const Key('avatar_option_1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('change_photo_avatar_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Ganti Foto Profil'), findsNothing);
    expect(find.text('Foto profil berhasil diperbarui'), findsOneWidget);

    final saved = await store.read();
    expect(saved, isNotNull);
    expect(saved!.assetPath, ProfileAvatarOption.builtIn[1].assetPath);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                ProfileAvatarOption.builtIn[1].assetPath,
      ),
      findsWidgets,
    );
  });

  testWidgets(
    'grid avatar memakai 8 aset, 3 kolom di mobile, simpan nonaktif sebelum memilih',
    (tester) async {
      setScreen(tester, const Size(412, 1055));
      final store = InMemoryProfilePhotoStore();

      await tester.pumpWidget(
        MaterialApp(
          home: ProfileScreen(
            profilePhotoService: ProfilePhotoService(store: store),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('profile_edit_avatar_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('change_photo_avatar_card')));
      await tester.pumpAndSettle();

      expect(find.text('Pilih karakter favoritmu!'), findsOneWidget);
      expect(find.byKey(const Key('avatar_option_7')), findsOneWidget);

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3);

      // Default pilihan ada di avatar pertama (Kucing).
      final semantics = tester.ensureSemantics();
      final cat = tester.getSemantics(find.byKey(const Key('avatar_option_0')));
      final panda = tester.getSemantics(
        find.byKey(const Key('avatar_option_1')),
      );
      expect(cat.flagsCollection.isSelected.name, 'isTrue');
      expect(panda.flagsCollection.isSelected.name, 'isFalse');
      semantics.dispose();

      // Belum ada pilihan berubah: tombol simpan harus nonaktif.
      await tester.tap(
        find.byKey(const Key('change_photo_avatar_save_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pilih Avatar'), findsOneWidget);
      expect(await store.read(), isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('grid avatar memakai 4 kolom di tablet', (tester) async {
    setScreen(tester, const Size(900, 900));
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          profilePhotoService: ProfilePhotoService(
            store: InMemoryProfilePhotoStore(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile_edit_avatar_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('change_photo_avatar_card')));
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('grid avatar aman di layar sangat sempit', (tester) async {
    setScreen(tester, const Size(320, 640));

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          profilePhotoService: ProfilePhotoService(
            store: InMemoryProfilePhotoStore(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile_edit_avatar_button')));
    await tester.pumpAndSettle();
    // Pada layar sempit kartu opsi berada di ListView horizontal.
    await tester.drag(
      find.byKey(const Key('change_photo_camera_card')),
      const Offset(-320, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('change_photo_avatar_card')));
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
    expect(
      find.byKey(const Key('change_photo_avatar_save_button')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
