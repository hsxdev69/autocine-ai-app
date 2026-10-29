import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timeline_editor_provider.dart';
import '../widgets/video_preview_canvas.dart';
import '../widgets/timeline_view.dart';

class CapCutEditorScreen extends StatelessWidget {
  const CapCutEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<TimelineEditorProvider>();
    final project = editor.project;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      appBar: AppBar(
        title: Text(
          project?.title ?? "CapCut Timeline Studio",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.download, size: 18),
            label: const Text("Export MP4", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Master Video exported to ${project?.masterVideoPath ?? '/storage/emulated/0/Download/yt2.0/'}!"),
                  backgroundColor: const Color(0xFF00E5FF),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Upper Half: Video Preview Canvas
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF0B0D13),
              child: const VideoPreviewCanvas(),
            ),
          ),

          // Middle Bar: Quick Edit Actions
          Container(
            height: 48,
            color: const Color(0xFF1A1D27),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickActionButton(
                  icon: Icons.refresh,
                  label: "Re-gen Scene",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Regenerating scene ${editor.selectedSceneIndex + 1} with AI...")),
                    );
                  },
                ),
                _quickActionButton(
                  icon: Icons.image_search,
                  label: "Swap Visual",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Opening B-Roll / Image Gallery...")),
                    );
                  },
                ),
                _quickActionButton(
                  icon: Icons.record_voice_over,
                  label: "Edit Voice",
                  onTap: () => _showEditVoiceDialog(context, editor),
                ),
                _quickActionButton(
                  icon: Icons.music_note,
                  label: "BGM Volume",
                  onTap: () => _showBgmVolumeDialog(context),
                ),
              ],
            ),
          ),

          // Lower Half: Multi-Track Timeline Scrubber (CapCut Style)
          const Expanded(
            flex: 5,
            child: TimelineView(),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF00E5FF)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showEditVoiceDialog(BuildContext context, TimelineEditorProvider editor) {
    if (editor.project == null || editor.project!.scenes.isEmpty) return;
    final scene = editor.project!.scenes[editor.selectedSceneIndex];
    final controller = TextEditingController(text: scene.narrationText);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E212D),
        title: Text("Edit Scene ${scene.sceneIndex} Narration", style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF141721),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
            child: const Text("Re-synthesize Voice", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              editor.updateSceneNarration(editor.selectedSceneIndex, controller.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Voiceover updated & synced with timeline!")),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showBgmVolumeDialog(BuildContext context) {
    double vol = 0.15;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF1E212D),
          title: const Text("Background Music Level", style: TextStyle(color: Colors.white, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Current Ducked Volume: ${(vol * 100).toInt()}%", style: const TextStyle(color: Colors.white70)),
              Slider(
                value: vol,
                min: 0.0,
                max: 1.0,
                activeColor: const Color(0xFF00E5FF),
                onChanged: (v) => setS(() => vol = v),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
              child: const Text("Apply", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
