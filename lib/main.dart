import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'data/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('bookmarks');
  await Hive.openBox('family_stars');
  await Hive.openBox('moi_records');

  await DatabaseHelper.instance.init();

  runApp(const ProviderScope(child: KaalakkaniApp()));
}

class KaalakkaniApp extends ConsumerWidget {
  const KaalakkaniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, settingsBox, _) {
        final isDark = settingsBox.get('dark_mode', defaultValue: false) as bool;

        return MaterialApp.router(
          title: 'காலக்கணி',
          debugShowCheckedModeBanner: false,
          theme: KaalakkaniTheme.light(),
          darkTheme: KaalakkaniTheme.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.system,
          routerConfig: appRouter,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  settingsBox.get('elder_mode', defaultValue: false) ? 1.40 : 1.15,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}

/// Flutter-side splash shown during Dart initialization (before router loads)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/app_icon.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 24),
                const Text(
                  'காலக்கணி',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4338CA),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'உங்கள் நாள்தோறும் நல்ல நாள்',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
