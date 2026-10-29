import 'package:flutter/material.dart';

class CaptionsOverlay extends StatelessWidget {
  final String text;
  final bool isBouncing;

  const CaptionsOverlay({
    Key? key,
    required this.text,
    this.isBouncing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Positioned(
      bottom: 60,
      left: 20,
      right: 20,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFEB3B), // High-retention yellow
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              shadows: [
                Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
