/// Merepresentasikan satu pilihan aksi di halaman Sketch to Story.
class SketchToStoryOption {
  const SketchToStoryOption({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  /// Identifier unik, dipakai controller untuk membedakan aksi.
  final String id;
  final String imagePath;
  final String title;
  final String description;

  @override
  String toString() =>
      'SketchToStoryOption(id: $id, title: $title)';
}
