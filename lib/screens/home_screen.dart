import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/video_generator_provider.dart';
import '../providers/timeline_editor_provider.dart';
import 'create_video_screen.dart';
import 'capcut_editor_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final generator = context.watch<VideoGeneratorProvider>();
    final projects = generator.projects;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.movie_filter, color: Color(0xFF00E5FF)),
            SizedBox(width: 8),
            Text("AutoCine AI Studio"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(Icons.video_library_outlined, size: 64, color: Color(0xFF00E5FF)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No AI Videos Created Yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Enter any topic (e.g. Doctor Doom Secrets or Deserted Island) to auto-generate a full viral video!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add, size: 22),
                    label: const Text("Create First Video", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateVideoScreen()));
                    },
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, idx) {
                final proj = projects[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  color: const Color(0xFF1E212D),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.4)),
                      ),
                      child: Icon(
                        proj.format == VideoFormat.shorts9x16 ? Icons.smartphone : Icons.tv,
                        color: const Color(0xFF00E5FF),
                      ),
                    ),
                    title: Text(
                      proj.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "Format: ${proj.format == VideoFormat.shorts9x16 ? '9:16 Shorts' : '16:9 Long'} • ${proj.scenes.length} Scenes",
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            proj.status.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
                    onTap: () {
                      context.read<TimelineEditorProvider>().loadProject(proj);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CapCutEditorScreen()),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00E5FF),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text("New Video", style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateVideoScreen()));
        },
      ),
    );
  }
}
