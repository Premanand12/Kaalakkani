import 'package:flutter/material.dart';

class KaalakkaniTheme {
  // Brand colours
  static const saffron = Color(0xFFC4520F);
  static const saffronDeep = Color(0xFF9E3F08);
  static const saffronLight = Color(0xFFF0784A);
  static const gold = Color(0xFFD4890A);
  static const goodGreen = Color(0xFF2D8A4E);
  static const badRed = Color(0xFFC0392B);
  static const warnAmber = Color(0xFFC07800);
  static const infoBlue = Color(0xFF1A6FAF);

  // Light background system
  static const bgPageLight = Color(0xFFFFF8F2);
  static const bgCardLight = Color(0xFFFFFFFF);
  static const bgCard2Light = Color(0xFFFFF3EB);
  static const bgNavLight = Color(0xFFFFFFFF);

  // Dark background system
  static const bgPageDark = Color(0xFF0E0805);
  static const bgCardDark = Color(0xFF1C1108);
  static const bgCard2Dark = Color(0xFF261508);
  static const bgNavDark = Color(0xFF150E05);

  static const _tamil = 'NotoSansTamil';

  static TextTheme _tamilTextTheme(BuildContext? context) {
    return const TextTheme(
      displayLarge:  TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w300, fontSize: 56),
      headlineLarge: TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w600, fontSize: 28),
      headlineMedium:TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w600, fontSize: 24),
      headlineSmall: TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w600, fontSize: 22),
      titleLarge:    TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w600, fontSize: 22),
      titleMedium:   TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w600, fontSize: 20),
      titleSmall:    TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w500, fontSize: 18),
      bodyLarge:     TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w400, fontSize: 19.5),
      bodyMedium:    TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w400, fontSize: 18.5),
      bodySmall:     TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w400, fontSize: 16.5),
      labelLarge:    TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w500, fontSize: 17.5),
      labelMedium:   TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w500, fontSize: 16),
      labelSmall:    TextStyle(fontFamily: _tamil, fontWeight: FontWeight.w500, fontSize: 14),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.light,
        primary: saffron,
        secondary: goodGreen,
        surface: bgCardLight,
        background: bgPageLight,
        onPrimary: Colors.white,
        onSurface: const Color(0xFF1A0A00),
      ),
      scaffoldBackgroundColor: bgPageLight,
      textTheme: _tamilTextTheme(null),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgPageLight,
        foregroundColor: Color(0xFF1A0A00),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _tamil,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A0A00),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgNavLight,
        selectedItemColor: saffron,
        unselectedItemColor: Color(0xFFA07050),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontFamily: _tamil, fontSize: 9, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: _tamil, fontSize: 9),
      ),
      cardTheme: CardThemeData(
        color: bgCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: saffron.withOpacity(0.08), width: 0.8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCardLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: saffron.withOpacity(0.1), width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: saffron.withOpacity(0.08), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: saffron, width: 1.2),
        ),
        labelStyle: const TextStyle(fontFamily: _tamil, fontSize: 12, color: Color(0xFF1A0A00)),
        hintStyle: TextStyle(fontFamily: _tamil, fontSize: 12, color: const Color(0xFF1A0A00).withOpacity(0.4)),
      ),
      dividerTheme: DividerThemeData(
        color: const Color(0xFF1A0A00).withOpacity(0.05),
        thickness: 0.5,
      ),
      extensions: const [KaalakkaniColors.light()],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.dark,
        primary: saffronLight,
        secondary: const Color(0xFF6FD98C),
        surface: bgCardDark,
        background: bgPageDark,
        onPrimary: Colors.white,
        onSurface: const Color(0xFFFFF0E6),
      ),
      scaffoldBackgroundColor: bgPageDark,
      textTheme: _tamilTextTheme(null).apply(
        bodyColor: const Color(0xFFFFF0E6),
        displayColor: const Color(0xFFFFF0E6),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgPageDark,
        foregroundColor: Color(0xFFFFF0E6),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _tamil,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFFF0E6),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgNavDark,
        selectedItemColor: Color(0xFFF0784A),
        unselectedItemColor: Color(0xFF8A6050),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontFamily: _tamil, fontSize: 9, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: _tamil, fontSize: 9),
      ),
      cardTheme: CardThemeData(
        color: bgCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: saffron.withOpacity(0.15), width: 0.8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: saffron.withOpacity(0.2), width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: saffron.withOpacity(0.15), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: saffronLight, width: 1.2),
        ),
        labelStyle: const TextStyle(fontFamily: _tamil, fontSize: 12, color: Color(0xFFFFF0E6)),
        hintStyle: TextStyle(fontFamily: _tamil, fontSize: 12, color: const Color(0xFFFFF0E6).withOpacity(0.4)),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.05),
        thickness: 0.5,
      ),
      extensions: const [KaalakkaniColors.dark()],
    );
  }
}

// Custom theme extension for app-specific colours
@immutable
class KaalakkaniColors extends ThemeExtension<KaalakkaniColors> {
  final Color good;
  final Color bad;
  final Color warn;
  final Color info;
  final Color goodBg;
  final Color badBg;
  final Color warnBg;
  final Color infoBg;
  final Color card2;
  final Color navBg;

  const KaalakkaniColors({
    required this.good, required this.bad, required this.warn, required this.info,
    required this.goodBg, required this.badBg, required this.warnBg, required this.infoBg,
    required this.card2, required this.navBg,
  });

  const KaalakkaniColors.light() : this(
    good: const Color(0xFF2D8A4E), bad: const Color(0xFFC0392B),
    warn: const Color(0xFFC07800), info: const Color(0xFF1A6FAF),
    goodBg: const Color(0xFFEAF5EE), badBg: const Color(0xFFFDECEA),
    warnBg: const Color(0xFFFEF4E0), infoBg: const Color(0xFFE8F2FB),
    card2: const Color(0xFFFFF3EB), navBg: const Color(0xFFFFFFFF),
  );

  const KaalakkaniColors.dark() : this(
    good: const Color(0xFF6FD98C), bad: const Color(0xFFFF8878),
    warn: const Color(0xFFFFD070), info: const Color(0xFF79B8F5),
    goodBg: const Color(0xFF041505), badBg: const Color(0xFF1A0500),
    warnBg: const Color(0xFF1A0F00), infoBg: const Color(0xFF020508),
    card2: const Color(0xFF261508), navBg: const Color(0xFF150E05),
  );

  @override
  KaalakkaniColors copyWith({Color? good, Color? bad, Color? warn, Color? info,
    Color? goodBg, Color? badBg, Color? warnBg, Color? infoBg, Color? card2, Color? navBg}) {
    return KaalakkaniColors(
      good: good ?? this.good, bad: bad ?? this.bad,
      warn: warn ?? this.warn, info: info ?? this.info,
      goodBg: goodBg ?? this.goodBg, badBg: badBg ?? this.badBg,
      warnBg: warnBg ?? this.warnBg, infoBg: infoBg ?? this.infoBg,
      card2: card2 ?? this.card2, navBg: navBg ?? this.navBg,
    );
  }

  @override
  KaalakkaniColors lerp(KaalakkaniColors? other, double t) {
    if (other is! KaalakkaniColors) return this;
    return KaalakkaniColors(
      good: Color.lerp(good, other.good, t)!, bad: Color.lerp(bad, other.bad, t)!,
      warn: Color.lerp(warn, other.warn, t)!, info: Color.lerp(info, other.info, t)!,
      goodBg: Color.lerp(goodBg, other.goodBg, t)!, badBg: Color.lerp(badBg, other.badBg, t)!,
      warnBg: Color.lerp(warnBg, other.warnBg, t)!, infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      card2: Color.lerp(card2, other.card2, t)!, navBg: Color.lerp(navBg, other.navBg, t)!,
    );
  }
}
