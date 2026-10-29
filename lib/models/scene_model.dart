enum CameraMotion { zoomIn, zoomOut, panLeft, panRight, panUp, none }

class SceneModel {
  final String id;
  int sceneIndex;
  String narrationText;
  String visualPrompt;
  String mediaPath; // URL or local file path
  bool isVideo;
  double duration; // seconds
  CameraMotion motion;

  SceneModel({
    required this.id,
    required this.sceneIndex,
    required this.narrationText,
    required this.visualPrompt,
    required this.mediaPath,
    this.isVideo = false,
    required this.duration,
    this.motion = CameraMotion.zoomIn,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sceneIndex': sceneIndex,
    'narrationText': narrationText,
    'visualPrompt': visualPrompt,
    'mediaPath': mediaPath,
    'isVideo': isVideo,
    'duration': duration,
    'motion': motion.toString().split('.').last,
  };

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
    id: json['id'] ?? '',
    sceneIndex: json['sceneIndex'] ?? 0,
    narrationText: json['narrationText'] ?? '',
    visualPrompt: json['visualPrompt'] ?? '',
    mediaPath: json['mediaPath'] ?? '',
    isVideo: json['isVideo'] ?? false,
    duration: (json['duration'] as num?)?.toDouble() ?? 5.0,
    motion: CameraMotion.values.firstWhere(
      (e) => e.toString().split('.').last == json['motion'],
      orElse: () => CameraMotion.zoomIn,
    ),
  );
}
