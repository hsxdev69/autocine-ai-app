import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/video_generator_provider.dart';
import '../providers/timeline_editor_provider.dart';
import 'capcut_editor_screen.dart';

class CreateVideoScreen extends StatefulWidget {
  const CreateVideoScreen({Key? key}) : super(key: key);

  @override
  State<CreateVideoScreen> createState() => _CreateVideoScreenState();
}

class _CreateVideoScreenState extends State<CreateVideoScreen> {
  final TextEditingController _topicController = TextEditingController();
  VideoFormat _selectedFormat = VideoFormat.shorts9x16;
  String _selectedMode = "Footage & Lore";
  String _selectedVoice = "hi-IN-MadhurNeural";
  String _selectedBgm = "Suspense Ticking Tension";

  final List<String> _suggestedTopics = [
    "Doctor Doom Secret Lore",
    "18 Girls on Deserted Island",
    "Iron Man Dark Truth",
    "Endgame Hidden Details",
  ];

  @override
  Widget build(BuildContext context) {
    final generator = context.watch<VideoGeneratorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Generate AI Video")),
      body: generator.isGenerating
          ? _buildProgressView(generator)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic Input Section
                  const Text("Enter Video Topic or Link", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _topicController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "e.g., Doctor Doom's Burning Mask or Island Survival...",
                      hintStyle: const TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: const Color(0xFF1A1D27),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Suggested chips
                  Wrap(
                    spacing: 8,
                    children: _suggestedTopics.map((t) {
                      return ActionChip(
                        label: Text(t, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF232736),
                        onPressed: () => setState(() => _topicController.text = t),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  // Format Selector
                  const Text("Select Video Format", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _formatCard(
                          icon: Icons.smartphone,
                          title: "9:16 Shorts / Reels",
                          subtitle: "Under 60s viral retention",
                          format: VideoFormat.shorts9x16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _formatCard(
                          icon: Icons.tv,
                          title: "16:9 Long Video",
                          subtitle: "Full episodic explanation",
                          format: VideoFormat.wide16x9,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Mode Selector
                  const Text("Production Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedMode,
                    dropdownColor: const Color(0xFF1E212D),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A1D27),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Footage & Lore", child: Text("🎞️ Footage & Movie B-Roll (Marvel/DC/Film)")),
                      DropdownMenuItem(value: "AI Anime Story", child: Text("🎨 AI Anime / Manhua Story Art (Survival/Novels)")),
                    ],
                    onChanged: (v) => setState(() => _selectedMode = v!),
                  ),

                  const SizedBox(height: 24),
                  // Voice Selector
                  const Text("Narrator Voice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedVoice,
                    dropdownColor: const Color(0xFF1E212D),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A1D27),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    items: const [
                      DropdownMenuItem(value: "hi-IN-MadhurNeural", child: Text("🎙️ Madhur (Deep Dramatic Hindi - Default)")),
                      DropdownMenuItem(value: "FmBhnvP58BK0vz65OOj7", child: Text("🎙️ Viraj (ElevenLabs Energetic Hindi)")),
                      DropdownMenuItem(value: "ur-IN-SalmanNeural", child: Text("🎙️ Salman (Velvety Smooth Suspense)")),
                    ],
                    onChanged: (v) => setState(() => _selectedVoice = v!),
                  ),

                  const SizedBox(height: 24),
                  // BGM Selector
                  const Text("Background Music Mood", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedBgm,
                    dropdownColor: const Color(0xFF1E212D),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A1D27),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Suspense Ticking Tension", child: Text("⏱️ Suspense Ticking Tension (High Retention)")),
                      DropdownMenuItem(value: "Emotional Cinematic Strings", child: Text("🎻 Emotional Cinematic Strings")),
                      DropdownMenuItem(value: "Epic Action Dark Bass", child: Text("🔥 Epic Action Dark Bass")),
                    ],
                    onChanged: (v) => setState(() => _selectedBgm = v!),
                  ),

                  const SizedBox(height: 36),
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () async {
                        if (_topicController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a topic first!")),
                          );
                          return;
                        }

                        final proj = await generator.startGeneration(
                          topic: _topicController.text.trim(),
                          format: _selectedFormat,
                          mode: _selectedMode,
                          voiceModel: _selectedVoice,
                          bgmMood: _selectedBgm,
                        );

                        if (context.mounted) {
                          context.read<TimelineEditorProvider>().loadProject(proj);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const CapCutEditorScreen()),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 22),
                          SizedBox(width: 8),
                          Text("Generate Video & Open Editor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _formatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VideoFormat format,
  }) {
    final isSelected = _selectedFormat == format;
    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = format),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00E5FF).withOpacity(0.12) : const Color(0xFF1A1D27),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E5FF) : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF00E5FF) : Colors.white54, size: 28),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white70, fontSize: 12)),
            const SizedBox(height: 2),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressView(VideoGeneratorProvider generator) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: generator.activeProject?.progress ?? 0.0,
                    strokeWidth: 8,
                    backgroundColor: Colors.white10,
                    color: const Color(0xFF00E5FF),
                  ),
                ),
                Text(
                  "${((generator.activeProject?.progress ?? 0.0) * 100).toInt()}%",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              generator.activeProject?.statusMessage ?? "Processing...",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF00E5FF)),
            ),
            const SizedBox(height: 12),
            const Text(
              "Auto-searching B-roll, synthesizing voiceover, and applying CapCut camera animations...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
