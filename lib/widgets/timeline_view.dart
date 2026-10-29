import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timeline_track_model.dart';
import '../providers/timeline_editor_provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<TimelineEditorProvider>();
    final project = editor.project;
    if (project == null) return const SizedBox.shrink();

    final totalDur = project.totalDuration > 0 ? project.totalDuration : 1.0;

    return Container(
      color: const Color(0xFF13151F),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Ruler & Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        editor.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        color: const Color(0xFF00E5FF),
                        size: 28,
                      ),
                      onPressed: () => editor.togglePlay(),
                    ),
                    Text(
                      "${editor.currentTime.toStringAsFixed(1)}s",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        editor.bouncingCaptionsEnabled ? Icons.subtitles : Icons.subtitles_off,
                        color: editor.bouncingCaptionsEnabled ? const Color(0xFFFFB300) : Colors.white38,
                        size: 22,
                      ),
                      onPressed: () => editor.toggleBouncingCaptions(),
                      tooltip: "Toggle Captions",
                    ),
                    IconButton(
                      icon: const Icon(Icons.content_cut, color: Colors.white70, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Clip split at current playhead position!")),
                        );
                      },
                      tooltip: "Split Clip",
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFF232736)),

          // Multi-Track Timeline Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: editor.tracks.length,
              itemBuilder: (context, trackIdx) {
                final track = editor.tracks[trackIdx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Track Label
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 2),
                        child: Text(
                          track.name,
                          style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),

                      // Track Ribbon
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E212D),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: track.clips.length,
                          itemBuilder: (context, clipIdx) {
                            final clip = track.clips[clipIdx];
                            final isSelected = track.type == TrackType.visuals && clipIdx == editor.selectedSceneIndex;
                            final width = (clip.duration / totalDur) * 320.0 + 80.0;

                            Color clipColor;
                            switch (track.type) {
                              case TrackType.visuals:
                                clipColor = isSelected ? const Color(0xFF00E5FF) : const Color(0xFF2C3247);
                                break;
                              case TrackType.voiceover:
                                clipColor = const Color(0xFF1E40AF);
                                break;
                              case TrackType.music:
                                clipColor = const Color(0xFF831843);
                                break;
                              case TrackType.captions:
                                clipColor = const Color(0xFF78350F);
                                break;
                            }

                            return GestureDetector(
                              onTap: () {
                                if (track.type == TrackType.visuals) {
                                  editor.selectScene(clipIdx);
                                }
                              },
                              child: Container(
                                width: width,
                                margin: const EdgeInsets.all(3),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: clipColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                                ),
                                child: Center(
                                  child: Text(
                                    clip.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.white,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
