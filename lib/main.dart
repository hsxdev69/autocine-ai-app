import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/video_generator_provider.dart';
import 'providers/timeline_editor_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoGeneratorProvider()),
        ChangeNotifierProvider(create: (_) => TimelineEditorProvider()),
      ],
      child: const AutoCineApp(),
    ),
  );
}

class AutoCineApp extends StatelessWidget {
  const AutoCineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoCine AI Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
