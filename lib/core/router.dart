import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/month/month_screen.dart';
import '../screens/rasipalan/rasipalan_screen.dart';
import '../screens/muhurtham/muhurtham_screen.dart';
import '../screens/more/more_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/tools/porutham_screen.dart';
import '../screens/tools/baby_names_screen.dart';
import '../screens/tools/numerology_screen.dart';
import '../screens/tools/moi_register_screen.dart';
import '../screens/tools/palli_palangal_screen.dart';
import '../screens/tools/gold_rate_screen.dart';
import '../screens/tools/kanavu_palangal_screen.dart';
import '../screens/tools/family_star_book_screen.dart';
import '../screens/tools/thirukkural_screen.dart';
import '../screens/tools/share_card_screen.dart';
import '../screens/tools/tamil_date_converter_screen.dart';
import '../widgets/shell_scaffold.dart';
import 'package:hive_flutter/hive_flutter.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const _SplashGate(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    // Full-screen sub-routes pushed on top of the tab shell
    GoRoute(path: '/settings',        builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/porutham',        builder: (_, __) => const PoruthamScreen()),
    GoRoute(path: '/baby-names',      builder: (_, __) => const BabyNamesScreen()),
    GoRoute(path: '/numerology',      builder: (_, __) => const NumerologyScreen()),
    GoRoute(path: '/moi',             builder: (_, __) => const MoiRegisterScreen()),
    GoRoute(path: '/palli',           builder: (_, __) => const PalliPalangalScreen()),
    GoRoute(path: '/gold',            builder: (_, __) => const GoldRateScreen()),
    GoRoute(path: '/kanavu',          builder: (_, __) => const KanavuPalangalScreen()),
    GoRoute(path: '/family-stars',    builder: (_, __) => const FamilyStarBookScreen()),
    GoRoute(path: '/thirukkural',     builder: (_, __) => const ThirukkuralScreen()),
    GoRoute(path: '/share-card',      builder: (_, __) => const ShareCardScreen()),
    GoRoute(path: '/date-converter',  builder: (_, __) => const TamilDateConverterScreen()),

    ShellRoute(
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(path: '/',                builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/month',           builder: (_, __) => const MonthScreen()),
        GoRoute(path: '/rasipalan',       builder: (_, __) => const RasipalanScreen()),
        GoRoute(path: '/muhurtham',       builder: (_, __) => const MuhurthamScreen()),
        GoRoute(path: '/more',            builder: (_, __) => const MoreScreen()),
      ],
    ),
  ],
);

String _initialRoute() {
  final box = Hive.box('settings');
  final onboarded = box.get('onboarded', defaultValue: false) as bool;
  return onboarded ? '/' : '/onboarding';
}

class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) context.go(_initialRoute());
    });
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}
