class AppConstants {
  static const String dbName = 'kaalakkani.db';
  static const String dbAssetPath = 'assets/db/kaalakkani.db';

  static const List<String> rasiNamesTa = [
    'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்',
    'சிம்மம்', 'கன்னி', 'துலாம்', 'விருச்சிகம்',
    'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
  ];

  static const List<String> nakshatraNamesTa = [
    'அஸ்வினி', 'பரணி', 'கார்த்திகை', 'ரோஹிணி',
    'மிருகசீரிஷம்', 'திருவாதிரை', 'புனர்பூசம்', 'பூசம்',
    'ஆயில்யம்', 'மகம்', 'பூரம்', 'உத்திரம்',
    'ஹஸ்தம்', 'சித்திரை', 'சுவாதி', 'விசாகம்',
    'அனுஷம்', 'கேட்டை', 'மூலம்', 'பூராடம்',
    'உத்திராடம்', 'திருவோணம்', 'அவிட்டம்', 'சதயம்',
    'பூரட்டாதி', 'உத்தரட்டாதி', 'ரேவதி',
  ];

  static const List<String> tamilMonthsTa = [
    'சித்திரை', 'வைகாசி', 'ஆனி', 'ஆடி',
    'ஆவணி', 'புரட்டாசி', 'ஐப்பசி', 'கார்த்திகை',
    'மார்கழி', 'தை', 'மாசி', 'பங்குனி',
  ];

  static const List<String> weekdaysTa = [
    'ஞாயிறு', 'திங்கள்', 'செவ்வாய்',
    'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி',
  ];

  // Chandrashtamam: rasiIndex → chandrashtamam rasi index (8th from it)
  static int chandrashtamamFor(int rasiIndex) => (rasiIndex + 7) % 12;
}
