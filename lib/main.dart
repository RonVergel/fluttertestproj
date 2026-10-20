import 'package:flutter/material.dart';
import 'screens/camera_home_screen.dart';
import 'services/snap_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = SnapRepository();
  runApp(SnapApp(repository: repository));
}

class SnapApp extends StatelessWidget {
  const SnapApp({
    super.key,
    required this.repository,
  });

  final SnapRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snap & Gallery Note',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: CameraHomeScreen(repository: repository),
    );
  }
}
