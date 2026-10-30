import '../../../core/constants/asset_paths.dart';
import '../models/mission_item.dart';

abstract interface class MissionRepository {
  List<MissionItem> getMissions();
}

class MockMissionRepository implements MissionRepository {
  const MockMissionRepository();

  @override
  List<MissionItem> getMissions() {
    return const [
      MissionItem(
        id: 'mission_1',
        title: 'Menggambar apel merah',
        category: 'Sketch Challenge',
        currentProgress: 0,
        totalProgress: 1,
        reward: 20,
        status: MissionStatus.notStarted,
        iconPath: AssetPaths.missionApple,
        actionLabel: 'Mulai',
      ),
      MissionItem(
        id: 'mission_2',
        title: 'Selesaikan 3 permainan',
        category: 'Petualangan hari ini',
        currentProgress: 3,
        totalProgress: 3,
        reward: 20,
        status: MissionStatus.completed,
        iconPath: AssetPaths.missionGames,
        actionLabel: 'Selesai',
      ),
      MissionItem(
        id: 'mission_3',
        title: 'Ubah gambar jadi cerita',
        category: 'Sketch-to-Story',
        currentProgress: 0,
        totalProgress: 1,
        reward: 30,
        status: MissionStatus.notStarted,
        iconPath: AssetPaths.missionStory,
        actionLabel: 'Mulai',
      ),
      MissionItem(
        id: 'mission_4',
        title: 'Pakai 5 warna berbeda',
        category: 'Sketch Challenge',
        currentProgress: 3,
        totalProgress: 5,
        reward: 25,
        status: MissionStatus.inProgress,
        iconPath: AssetPaths.missionPalette,
        actionLabel: 'Lanjut',
      ),
    ];
  }
}
