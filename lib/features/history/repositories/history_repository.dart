import '../models/history_artwork_model.dart';

abstract interface class HistoryRepository {
  Future<List<HistoryArtwork>> fetchHistory();
}
