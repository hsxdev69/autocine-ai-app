package com.autocine.app

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.autocine.app/gallery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveToGallery") {
                val sourcePath = call.argument<String>("filePath")
                val title = call.argument<String>("title") ?: "AutoCine_Video"
                if (sourcePath == null) {
                    result.error("INVALID_PATH", "File path is null", null)
                    return@setMethodCallHandler
                }

                try {
                    val srcFile = File(sourcePath)
                    if (!srcFile.exists()) {
                        result.error("FILE_NOT_FOUND", "Source file does not exist: $sourcePath", null)
                        return@setMethodCallHandler
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        val values = ContentValues().apply {
                            put(MediaStore.Video.Media.DISPLAY_NAME, "${title}_${System.currentTimeMillis()}.mp4")
                            put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
                            put(MediaStore.Video.Media.RELATIVE_PATH, Environment.DIRECTORY_DCIM + "/AutoCine")
                            put(MediaStore.Video.Media.IS_PENDING, 1)
                        }

                        val uri = applicationContext.contentResolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, values)
                        if (uri != null) {
                            applicationContext.contentResolver.openOutputStream(uri)?.use { outStream ->
                                FileInputStream(srcFile).use { inStream ->
                                    inStream.copyTo(outStream)
                                }
                            }
                            values.clear()
                            values.put(MediaStore.Video.Media.IS_PENDING, 0)
                            applicationContext.contentResolver.update(uri, values, null, null)

                            MediaScannerConnection.scanFile(
                                applicationContext,
                                arrayOf(uri.toString()),
                                arrayOf("video/mp4")
                            ) { _, _ -> }

                            result.success(uri.toString())
                            return@setMethodCallHandler
                        }
                    }

                    // Fallback for DCIM/AutoCine directory
                    val dcimDir = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), "AutoCine")
                    if (!dcimDir.exists()) dcimDir.mkdirs()
                    val destFile = File(dcimDir, "${title}_${System.currentTimeMillis()}.mp4")
                    srcFile.copyTo(destFile, overwrite = true)

                    MediaScannerConnection.scanFile(
                        applicationContext,
                        arrayOf(destFile.absolutePath),
                        arrayOf("video/mp4")
                    ) { path, _ -> }

                    result.success(destFile.absolutePath)
                } catch (e: Exception) {
                    result.error("EXPORT_FAILED", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
