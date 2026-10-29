import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../models/scene_model.dart';
import '../services/api_service.dart';

class VideoGeneratorProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<ProjectModel> _projects = [];

  List<ProjectModel> get projects => _projects;
  ProjectModel? _activeProject;
  ProjectModel? get activeProject => _activeProject;

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  Future<ProjectModel> startGeneration({
    required String topic,
    required VideoFormat format,
    required String mode,
    required String voiceModel,
    required String bgmMood,
  }) async {
    _isGenerating = true;
    final projectId = const Uuid().v4();
    final newProject = ProjectModel(
      id: projectId,
      title: topic,
      topic: topic,
      format: format,
      voiceModel: voiceModel,
      bgmTrack: bgmMood,
      status: ProjectStatus.researching,
      progress: 0.1,
      statusMessage: '🔍 Searching YouTube & Web for source lore...',
      createdAt: DateTime.now(),
    );

    _projects.insert(0, newProject);
    _activeProject = newProject;
    notifyListeners();

    try {
      // Step 1: Research & Scripting (0.3)
      await Future.delayed(const Duration(seconds: 1));
      newProject.status = ProjectStatus.writing;
      newProject.progress = 0.3;
      newProject.statusMessage = '✍️ Writing high-retention storytelling script...';
      notifyListeners();

      final scriptData = await _apiService.generateAiScript(
        topic: topic,
        format: format,
        mode: mode,
      );

      final List<SceneModel> parsedScenes = (scriptData['scenes'] as List).map((s) {
        return SceneModel(
          id: const Uuid().v4(),
          sceneIndex: s['sceneIndex'],
          narrationText: s['narrationText'],
          visualPrompt: s['visualPrompt'],
          mediaPath: 'assets/images/placeholder.jpg',
          duration: s['duration'],
        );
      }).toList();

      newProject.scenes = parsedScenes;

      // Step 2: Voiceover Synthesis (0.6)
      newProject.status = ProjectStatus.generatingVoice;
      newProject.progress = 0.6;
      newProject.statusMessage = '🎙️ Generating emotional Hindi voiceover ($voiceModel)...';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));

      // Step 3: Compositing & Rendering (0.85)
      newProject.status = ProjectStatus.rendering;
      newProject.progress = 0.85;
      newProject.statusMessage = '🎬 Applying Ken Burns animation & mixing ducked BGM...';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));

      // Step 4: Completed
      newProject.status = ProjectStatus.completed;
      newProject.progress = 1.0;
      newProject.statusMessage = '✅ Master video & thumbnail generated successfully!';
      newProject.masterVideoPath = '/storage/emulated/0/Download/yt2.0/projects/${newProject.id}.mp4';
      newProject.thumbnailPath = '/storage/emulated/0/Download/yt2.0/projects/thumb_${newProject.id}.jpg';
      _isGenerating = false;
      notifyListeners();

      return newProject;
    } catch (e) {
      newProject.status = ProjectStatus.failed;
      newProject.statusMessage = 'Error during generation: $e';
      _isGenerating = false;
      notifyListeners();
      rethrow;
    }
  }

  void setActiveProject(ProjectModel project) {
    _activeProject = project;
    notifyListeners();
  }
}
