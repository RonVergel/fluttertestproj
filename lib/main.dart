import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/student_id_entry_screen.dart';
import 'services/snap_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>(SnapRepository.boxName);
  final repository = SnapRepository(box);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => SnapApp(repository: repository),
    ),
  );
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
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF902E2B),
          secondary: Color(0xFFECB843),
          surface: Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF902E2B),
          elevation: 0,
        ),
      ),
      home: StudentIdEntryScreen(repository: repository),
    );
  }
}
