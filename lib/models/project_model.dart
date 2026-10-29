import 'scene_model.dart';

enum VideoFormat { shorts9x16, wide16x9 }
enum ProjectStatus { draft, researching, writing, generatingVoice, rendering, completed, failed }

class ProjectModel {
  final String id;
  String title;
  String topic;
  VideoFormat format;
  ProjectStatus status;
  double progress; // 0.0 to 1.0
  String statusMessage;
  List<SceneModel> scenes;
  String? masterVideoPath;
  String? thumbnailPath;
  String? bgmTrack;
  String voiceModel;
  double targetDuration; // accurate seconds requested by user
  DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.topic,
    this.format = VideoFormat.shorts9x16,
    this.status = ProjectStatus.draft,
    this.progress = 0.0,
    this.statusMessage = 'Initialized',
    this.scenes = const [],
    this.masterVideoPath,
    this.thumbnailPath,
    this.bgmTrack,
    this.voiceModel = 'hi-IN-MadhurNeural',
    this.targetDuration = 30.0,
    required this.createdAt,
  });

  double get totalDuration => scenes.isNotEmpty
      ? scenes.fold(0.0, (acc, s) => acc + s.duration)
      : targetDuration;
}
