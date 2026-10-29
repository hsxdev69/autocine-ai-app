import 'dart:io';
import 'package:flutter/services.dart';

class GalleryService {
  static const MethodChannel _channel = MethodChannel('com.autocine.app/gallery');

  /// Saves a video file directly to Android Gallery (DCIM/AutoCine)
  /// and registers it with Android MediaStore scanner so it shows up in Gallery instantly.
  static Future<String?> saveVideoToGallery({
    required String filePath,
    String title = "AutoCine_Reel",
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      // 1. Invoke native MediaStore channel
      final dynamic result = await _channel.invokeMethod('saveToGallery', {
        'filePath': filePath,
        'title': title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_'),
      });

      return result?.toString();
    } catch (e) {
      // 2. Direct Fallback to DCIM directory
      try {
        final dcimDir = Directory('/storage/emulated/0/DCIM/AutoCine');
        if (!await dcimDir.exists()) {
          await dcimDir.create(recursive: true);
        }
        final cleanTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
        final destPath = '${dcimDir.path}/${cleanTitle}_${DateTime.now().millisecondsSinceEpoch}.mp4';
        await File(filePath).copy(destPath);
        return destPath;
      } catch (_) {
        return null;
      }
    }
  }
}
