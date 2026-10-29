import 'package:flutter/foundation.dart';
import '../models/project_model.dart';
import '../models/scene_model.dart';
import '../models/timeline_track_model.dart';

class TimelineEditorProvider extends ChangeNotifier {
  ProjectModel? _project;
  ProjectModel? get project => _project;

  double _currentTime = 0.0;
  double get currentTime => _currentTime;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  List<TimelineTrack> _tracks = [];
  List<TimelineTrack> get tracks => _tracks;

  int _selectedSceneIndex = 0;
  int get selectedSceneIndex => _selectedSceneIndex;

  // Subtitle customizer
  bool _bouncingCaptionsEnabled = true;
  bool get bouncingCaptionsEnabled => _bouncingCaptionsEnabled;

  void loadProject(ProjectModel project) {
    _project = project;
    _currentTime = 0.0;
    _isPlaying = false;
    _buildTracksFromProject();
    notifyListeners();
  }

  void _buildTracksFromProject() {
    if (_project == null) return;

    double runningTime = 0.0;
    final visualClips = <TimelineClip>[];
    final voClips = <TimelineClip>[];

    for (var scene in _project!.scenes) {
      visualClips.add(TimelineClip(
        id: 'vis_${scene.id}',
        title: 'Scene ${scene.sceneIndex}: ${scene.searchQuery.isNotEmpty ? scene.searchQuery : "Visual"}',
        startTime: runningTime,
        duration: scene.duration,
        mediaRef: scene.mediaPath.isNotEmpty ? scene.mediaPath : scene.thumbnailUrl,
      ));

      voClips.add(TimelineClip(
        id: 'vo_${scene.id}',
        title: scene.narrationText,
        startTime: runningTime,
        duration: scene.duration,
        mediaRef: scene.audioPath.isNotEmpty ? scene.audioPath : 'vo_${scene.sceneIndex}.mp3',
      ));

      runningTime += scene.duration;
    }

    _tracks = [
      TimelineTrack(
        id: 'track_visuals',
        type: TrackType.visuals,
        name: '🎞️ Visuals & B-roll',
        clips: visualClips,
      ),
      TimelineTrack(
        id: 'track_voice',
        type: TrackType.voiceover,
        name: '🎙️ Voiceover Audio',
        clips: voClips,
      ),
      TimelineTrack(
        id: 'track_music',
        type: TrackType.music,
        name: '🎵 Suspense BGM',
        volume: 0.15,
        clips: [
          TimelineClip(
            id: 'bgm_full',
            title: 'Ticking Suspense Score',
            startTime: 0.0,
            duration: runningTime,
            mediaRef: 'bgm.mp3',
          )
        ],
      ),
      TimelineTrack(
        id: 'track_captions',
        type: TrackType.captions,
        name: '🔤 Dynamic Captions',
        clips: voClips,
      ),
    ];
  }

  void seekTo(double time) {
    if (_project == null) return;
    _currentTime = time.clamp(0.0, _project!.totalDuration);
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void selectScene(int index) {
    if (_project != null && index >= 0 && index < _project!.scenes.length) {
      _selectedSceneIndex = index;
      double seekTime = 0.0;
      for (int i = 0; i < index; i++) {
        seekTime += _project!.scenes[i].duration;
      }
      seekTo(seekTime);
    }
  }

  void updateSceneNarration(int index, String newText) {
    if (_project != null && index >= 0 && index < _project!.scenes.length) {
      _project!.scenes[index].narrationText = newText;
      _buildTracksFromProject();
      notifyListeners();
    }
  }

  void updateSceneDuration(int index, double newDuration) {
    if (_project != null && index >= 0 && index < _project!.scenes.length) {
      _project!.scenes[index].duration = newDuration;
      _buildTracksFromProject();
      notifyListeners();
    }
  }

  void toggleBouncingCaptions() {
    _bouncingCaptionsEnabled = !_bouncingCaptionsEnabled;
    notifyListeners();
  }
}
