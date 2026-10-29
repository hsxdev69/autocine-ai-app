import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';
import '../models/scene_model.dart';

class ApiService {
  static const String defaultBackendUrl = "http://10.0.2.2:8000"; // standard Android emulator host

  Future<Map<String, dynamic>> generateAiScript({
    required String topic,
    required VideoFormat format,
    required String mode,
    String? customApiKey,
  }) async {
    // Simulating / Calling the Python Backend Orchestrator
    await Future.delayed(const Duration(milliseconds: 1200));

    // Return realistic structured storyboard JSON
    return {
      "title": topic,
      "format": format == VideoFormat.shorts9x16 ? "9:16" : "16:9",
      "scenes": [
        {
          "sceneIndex": 1,
          "narrationText": "सोचो... $topic के बारे में एक ऐसा गुप्त रहस्य जो आज तक किसी ने नहीं बताया!",
          "visualPrompt": "Dramatic cinematic scene establishing $topic with intense dynamic lighting",
          "duration": 5.0,
          "motion": "zoomIn"
        },
        {
          "sceneIndex": 2,
          "narrationText": "कहानी शुरू होती है जब सब कुछ अचानक बदल गया...",
          "visualPrompt": "Close up emotional confrontation scene, high contrast anime manhua style",
          "duration": 6.5,
          "motion": "panRight"
        },
        {
          "sceneIndex": 3,
          "narrationText": "लेकिन असली ट्विस्ट तो तब आया जब सच्चाई सामने आई!",
          "visualPrompt": "Epic hero moment with electric aura and shockwave particles",
          "duration": 7.0,
          "motion": "zoomOut"
        },
        {
          "sceneIndex": 4,
          "narrationText": "क्या आप इस रहस्य के बारे में पहले से जानते थे? कमेंट्स में जरूर बताएं!",
          "visualPrompt": "Suspenseful cliffhanger aesthetic with cinematic depth of field",
          "duration": 4.5,
          "motion": "panUp"
        }
      ]
    };
  }

  Future<String> synthesizeVoiceover({
    required String text,
    required String voiceId,
    String? elevenLabsApiKey,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return "voice_cache_${DateTime.now().millisecondsSinceEpoch}.mp3";
  }
}
