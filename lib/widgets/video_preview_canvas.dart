import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/timeline_editor_provider.dart';
import 'captions_overlay.dart';

class VideoPreviewCanvas extends StatelessWidget {
  const VideoPreviewCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<TimelineEditorProvider>();
    final project = editor.project;
    if (project == null) {
      return const Center(child: Text("No project loaded"));
    }

    final isShorts = project.format == VideoFormat.shorts9x16;
    final activeScene = project.scenes.isNotEmpty && editor.selectedSceneIndex < project.scenes.length
        ? project.scenes[editor.selectedSceneIndex]
        : null;

    return Center(
      child: AspectRatio(
        aspectRatio: isShorts ? 9 / 16 : 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF232736), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 4,
              )
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Canvas Background / Scene Visual
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: const Color(0xFF141721),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isShorts ? Icons.smartphone : Icons.tv,
                          size: 48,
                          color: const Color(0xFF00E5FF).withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          activeScene != null ? "Scene ${activeScene.sceneIndex}" : "Preview",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            activeScene?.visualPrompt ?? "",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // Dynamic Captions Overlay (CapCut Style)
              if (activeScene != null && editor.bouncingCaptionsEnabled)
                CaptionsOverlay(text: activeScene.narrationText),

              // Play / Pause Indicator & Scrubber Time
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${editor.currentTime.toStringAsFixed(1)}s / ${project.totalDuration.toStringAsFixed(1)}s",
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              // Format Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF00E5FF), width: 1),
                  ),
                  child: Text(
                    isShorts ? "9:16 Shorts" : "16:9 Long",
                    style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Center Play/Pause Floating Action
              Center(
                child: GestureDetector(
                  onTap: () => editor.togglePlay(),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: Icon(
                      editor.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
