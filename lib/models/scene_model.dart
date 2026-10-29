enum CameraMotion { zoomIn, zoomOut, panLeft, panRight, panUp, none }

class SceneModel {
  final String id;
  int sceneIndex;
  String narrationText;
  String visualPrompt;
  String searchQuery;
  String mediaPath; // URL or local file path
  String streamUrl;
  String audioPath;
  String thumbnailUrl;
  bool isVideo;
  double duration; // seconds
  CameraMotion motion;

  SceneModel({
    required this.id,
    required this.sceneIndex,
    required this.narrationText,
    required this.visualPrompt,
    this.searchQuery = '',
    required this.mediaPath,
    this.streamUrl = '',
    this.audioPath = '',
    this.thumbnailUrl = '',
    this.isVideo = false,
    required this.duration,
    this.motion = CameraMotion.zoomIn,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sceneIndex': sceneIndex,
    'narrationText': narrationText,
    'visualPrompt': visualPrompt,
    'searchQuery': searchQuery,
    'mediaPath': mediaPath,
    'streamUrl': streamUrl,
    'audioPath': audioPath,
    'thumbnailUrl': thumbnailUrl,
    'isVideo': isVideo,
    'duration': duration,
    'motion': motion.toString().split('.').last,
  };

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
    id: json['id'] ?? '',
    sceneIndex: json['sceneIndex'] ?? 0,
    narrationText: json['narrationText'] ?? '',
    visualPrompt: json['visualPrompt'] ?? '',
    searchQuery: json['searchQuery'] ?? json['youtubeSearchQuery'] ?? '',
    mediaPath: json['mediaPath'] ?? '',
    streamUrl: json['streamUrl'] ?? '',
    audioPath: json['audioPath'] ?? '',
    thumbnailUrl: json['thumbnailUrl'] ?? '',
    isVideo: json['isVideo'] ?? false,
    duration: (json['duration'] as num?)?.toDouble() ?? 5.0,
    motion: CameraMotion.values.firstWhere(
      (e) => e.toString().split('.').last == json['motion'],
      orElse: () => CameraMotion.zoomIn,
    ),
  );
}
