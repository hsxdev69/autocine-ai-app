enum TrackType { visuals, voiceover, music, captions }

class TimelineClip {
  final String id;
  final String title;
  double startTime; // seconds
  double duration;  // seconds
  final String mediaRef;
  final Map<String, dynamic> metadata;

  TimelineClip({
    required this.id,
    required this.title,
    required this.startTime,
    required this.duration,
    required this.mediaRef,
    this.metadata = const {},
  });
}

class TimelineTrack {
  final String id;
  final TrackType type;
  final String name;
  bool isMuted;
  double volume;
  List<TimelineClip> clips;

  TimelineTrack({
    required this.id,
    required this.type,
    required this.name,
    this.isMuted = false,
    this.volume = 1.0,
    required this.clips,
  });
}
