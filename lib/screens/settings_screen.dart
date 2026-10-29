import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _elevenLabsKeyController = TextEditingController();
  final TextEditingController _geminiKeyController = TextEditingController();
  String _exportResolution = "1080p Full HD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings & API Keys")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("API Configuration", style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: _elevenLabsKeyController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "ElevenLabs API Key (Optional for Viraj voice)",
              labelStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: const Color(0xFF1E212D),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _geminiKeyController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Gemini / AI Script API Key (Optional)",
              labelStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: const Color(0xFF1E212D),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 28),
          const Text("Export & Storage", style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _exportResolution,
            dropdownColor: const Color(0xFF1E212D),
            decoration: InputDecoration(
              labelText: "Default Render Quality",
              filled: true,
              fillColor: const Color(0xFF1E212D),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: const [
              DropdownMenuItem(value: "720p HD", child: Text("720p HD (Faster Export)")),
              DropdownMenuItem(value: "1080p Full HD", child: Text("1080p Full HD (Recommended)")),
              DropdownMenuItem(value: "4K Ultra HD", child: Text("4K Ultra HD (Maximum Detail)")),
            ],
            onChanged: (v) => setState(() => _exportResolution = v!),
          ),
          const SizedBox(height: 24),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: const Color(0xFF1E212D),
            leading: const Icon(Icons.folder, color: Color(0xFF00E5FF)),
            title: const Text("Export Destination", style: TextStyle(color: Colors.white, fontSize: 14)),
            subtitle: const Text("/storage/emulated/0/Download/yt2.0/", style: TextStyle(color: Colors.white38, fontSize: 12)),
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings saved successfully!")),
              );
              Navigator.pop(context);
            },
            child: const Text("Save Preferences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
