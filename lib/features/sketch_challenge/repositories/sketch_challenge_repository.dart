import '../models/level_item_model.dart';

abstract interface class SketchChallengeLevelRepository {
  Future<List<LevelItem>> fetchLevels();
}
