/// Panchangam Engine — Pure Dart calculations
/// No internet needed. All formulas are traditional Gowri Panchangam tables.
/// Swiss Ephemeris data is pre-computed in the SQLite database.
/// This file handles runtime calculations: Horai, live Chandrashtamam, etc.

class PanchangamEngine {
  PanchangamEngine._();
  static final PanchangamEngine instance = PanchangamEngine._();

  // ── Nalla Neram ────────────────────────────────────────────────────────────
  // Gowri Panchangam table: slot number (1-8) by weekday
  // Weekday: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
  static const List<int> _gowriSlot = [1, 3, 6, 5, 4, 7, 2];

  /// Returns Nalla Neram start and end times as strings
  static ({String start, String end}) nallaNeramForDay(
      String sunrise, String sunset, int weekday) {
    return _slotTimes(sunrise, sunset, _gowriSlot[weekday]);
  }

  // ── Rahukaalam ────────────────────────────────────────────────────────────
  static const List<int> _rahuSlot = [7, 1, 6, 4, 5, 3, 2];

  static ({String start, String end}) rahukaalamForDay(
      String sunrise, String sunset, int weekday) {
    return _slotTimes(sunrise, sunset, _rahuSlot[weekday]);
  }

  // ── Yamagandam ─────────────────────────────────────────────────────────────
  static const List<int> _yamaSlot = [4, 5, 3, 2, 1, 6, 7];

  static ({String start, String end}) yamakandamForDay(
      String sunrise, String sunset, int weekday) {
    return _slotTimes(sunrise, sunset, _yamaSlot[weekday]);
  }

  // ── Kuligai ────────────────────────────────────────────────────────────────
  static const List<int> _kuliSlot = [3, 2, 7, 5, 6, 4, 1];

  static ({String start, String end}) kuligaiForDay(
      String sunrise, String sunset, int weekday) {
    return _slotTimes(sunrise, sunset, _kuliSlot[weekday]);
  }

  // ── Soolam ─────────────────────────────────────────────────────────────────
  static const List<String> _soolamDir = [
    'தெற்கு', 'கிழக்கு', 'வடக்கு', 'மேற்கு',
    'தெற்கு', 'மேற்கு', 'கிழக்கு',
  ];
  static const List<String> _soolamRem = [
    'நல்லெண்ணெய்', 'தயிர்', 'பால்', 'வெல்லம்',
    'நல்லெண்ணெய்', 'வெல்லம்', 'தயிர்',
  ];

  static ({String direction, String remedy}) soolamForDay(int weekday) {
    return (direction: _soolamDir[weekday], remedy: _soolamRem[weekday]);
  }

  // ── Horai (planetary hour) ─────────────────────────────────────────────────
  // Each day starts with its ruling planet and follows the Chaldean order
  static const List<String> _horai = [
    'சூரியன்', 'வெள்ளி', 'புதன்', 'சந்திரன்',
    'சனி', 'வியாழன்', 'செவ்வாய்',
  ];
  // Day rulers: Sun Mon Tue Wed Thu Fri Sat → start slot index in _horai
  static const List<int> _dayRuler = [0, 3, 6, 2, 5, 1, 4];

  /// Returns list of 24 horai periods for the day
  static List<({String planet, String start, String end})> horaiForDay(
      String sunrise, DateTime date) {
    final wd = date.weekday % 7; // 0=Sun
    final List<({String planet, String start, String end})> result = [];
    final srFloat = _hm(sunrise);
    for (int i = 0; i < 24; i++) {
      final planetIdx = (_dayRuler[wd] + i) % 7;
      final startH = (srFloat + i).toDouble();
      final endH = startH + 1.0;
      result.add((
        planet: _horai[planetIdx],
        start: _fh(startH % 24),
        end: _fh(endH % 24),
      ));
    }
    return result;
  }

  // ── Pancha Pakshi Shastra ──────────────────────────────────────────────────
  // Five birds ruling time periods, based on rasi and day/night
  static const List<String> _birds = [
    'வல்லூறு', 'ஆந்தை', 'காகம்', 'கோழி', 'மயில்',
  ];
  static const List<String> _birdActivities = [
    'ஆட்சி', 'உண்ணல்', 'நடை', 'தூக்கம்', 'மரணம்',
  ];

  static String panchaPakshiActivity(int rasiIndex, DateTime now, String sunrise) {
    final srH = _hm(sunrise);
    final nowH = now.hour + now.minute / 60.0;
    final dayFrac = (nowH - srH) / 12.0;
    final birdIdx = (rasiIndex + (dayFrac * 5).floor()) % 5;
    final actIdx = ((dayFrac * 5).floor()) % 5;
    return '${_birds[birdIdx]} — ${_birdActivities[actIdx]}';
  }

  // ── Chandrashtamam ─────────────────────────────────────────────────────────
  static const List<String> _rasiTa = [
    'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்', 'சிம்மம்', 'கன்னி',
    'துலாம்', 'விருச்சிகம்', 'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
  ];

  static String chandrashtamamRasi(String moonRasi) {
    final moonIdx = _rasiTa.indexOf(moonRasi);
    if (moonIdx < 0) return '';
    return _rasiTa[(moonIdx + 7) % 12];
  }

  static bool isUserRasiAffected(String userRasi, String chandrashtamamRasi) {
    return userRasi == chandrashtamamRasi;
  }

  // ── Tamil date converter ───────────────────────────────────────────────────
  static const List<String> _tamilMonths = [
    'சித்திரை', 'வைகாசி', 'ஆனி', 'ஆடி', 'ஆவணி', 'புரட்டாசி',
    'ஐப்பசி', 'கார்த்திகை', 'மார்கழி', 'தை', 'மாசி', 'பங்குனி',
  ];
  static const List<String> _tamilYears = [
    'பிரபவ','விபவ','சுக்ல','பிரமோதூத','பிரஜோத்பத்தி',
    'ஆங்கீரஸ','ஸ்ரீமுக','பவ','யுவ','தாது',
    'ஈஸ்வர','வெகுதான்ய','பிரமாதி','விக்ரம','விஷு',
    'சித்ரபானு','சுபானு','தாரண','பார்த்திவ','வ்யய',
    'சர்வஜித்','சர்வதாரி','விரோதி','விக்ருதி','கர',
    'நந்தன','விஜய','ஜய','மன்மத','துர்முகி',
    'ஹேவிலம்பி','விளம்பி','விகாரி','சார்வரி','பிலவ',
    'சுபகிருது','சோபகிருது','குரோதி','விஸ்வாவசு','பராபவ',
    'பிலவங்க','கீலக','சௌம்ய','சாதாரண','விரோதகிருது',
    'பரிதாபி','பிரமாதீச','ஆனந்த','ராக்ஷஸ','நல',
    'பிங்கள','காளயுக்தி','சித்தார்த்தி','ரௌத்ரி','துர்மதி',
    'துந்துபி','ருத்ரோத்காரி','ரக்தாக்ஷி','குரோதன','அக்ஷய',
  ];

  static ({String tamilMonth, String tamilYear, int tamilDay}) toTamilDate(DateTime d) {
    int idx = (d.month - 4) % 12;
    if (d.day < 14) idx = (idx - 1) % 12;
    final yearIdx = (d.year - 1987) % 60;
    // Approximate Tamil day
    final tamilDay = d.day >= 14 ? d.day - 13 : d.day + 18;
    return (
      tamilMonth: _tamilMonths[idx],
      tamilYear: _tamilYears[yearIdx],
      tamilDay: tamilDay,
    );
  }

  static String tamilMonthName(int monthIndex) => _tamilMonths[monthIndex % 12];
  static String tamilYearName(int yearOffset) => _tamilYears[yearOffset % 60];

  // ── Numerology ─────────────────────────────────────────────────────────────
  static int numerologyNumber(String name) {
    // Chaldean numerology table for Tamil/English
    const Map<String, int> chart = {
      'a':1,'i':1,'j':1,'q':1,'y':1,
      'b':2,'c':2,'k':2,'r':2,
      'g':3,'l':3,'s':3,
      'd':4,'m':4,'t':4,
      'e':5,'h':5,'n':5,'x':5,
      'u':6,'v':6,'w':6,
      'o':7,'z':7,
      'f':8,'p':8,
    };
    int total = 0;
    for (final ch in name.toLowerCase().split('')) {
      total += chart[ch] ?? 0;
    }
    while (total > 9) {
      total = total.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return total;
  }

  static int lifePathNumber(DateTime dob) {
    final digits = '${dob.day}${dob.month}${dob.year}'.split('').map(int.parse);
    int total = digits.reduce((a, b) => a + b);
    while (total > 9) {
      total = total.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return total;
  }

  // ── Porutham (marriage matching) ──────────────────────────────────────────

  static Map<String, bool> porutham(int star1, int star2) {
    return {
      'தின பொருத்தம்': _dinaPoru(star1, star2),
      'கண பொருத்தம்': _ganaPoru(star1, star2),
      'மஹேந்திர பொருத்தம்': _mahendPoru(star1, star2),
      'ஸ்திரீ தீர்க்க பொருத்தம்': _streeDeergPoru(star1, star2),
      'யோனி பொருத்தம்': _yoniPoru(star1, star2),
      'ராசி பொருத்தம்': _rasiPoru(star1, star2),
      'ராஜ்ஜு பொருத்தம்': _rajjuPoru(star1, star2),
      'வேதை பொருத்தம்': _vedhaPoru(star1, star2),
      'வஸ்ய பொருத்தம்': _vasyaPoru(star1, star2),
      'நாடி பொருத்தம்': _nadiPoru(star1, star2),
    };
  }

  static bool _dinaPoru(int s1, int s2) {
    final diff = (s2 - s1 + 27) % 27;
    return diff != 0 && diff != 9 && diff != 18;
  }

  static bool _ganaPoru(int s1, int s2) {
    // Gana groups: Deva(0), Manushya(1), Rakshasa(2)
    const gana = [0,2,0,0,1,2,0,0,2,2,0,0,1,1,0,1,2,2,2,1,0,0,1,2,0,0,1];
    final g1 = gana[s1 % 27]; final g2 = gana[s2 % 27];
    return g1 == g2 || (g1 == 0 && g2 == 1) || (g1 == 1 && g2 == 0);
  }

  static bool _mahendPoru(int s1, int s2) {
    final diff = (s2 - s1 + 27) % 27;
    return [4, 7, 10, 13, 16, 19, 22, 25].contains(diff);
  }

  static bool _streeDeergPoru(int s1, int s2) {
    return (s2 - s1 + 27) % 27 > 7;
  }

  static bool _yoniPoru(int s1, int s2) {
    // Simplified: same yoni or compatible yonis
    const yoni = [0,1,0,2,3,4,5,3,6,7,8,9,10,11,0,1,0,2,3,4,5,3,6,7,8,9,10];
    return yoni[s1 % 27] == yoni[s2 % 27];
  }

  static bool _rasiPoru(int s1, int s2) {
    final r1 = s1 ~/ 2; final r2 = s2 ~/ 2;
    final diff = (r2 - r1 + 12) % 12;
    return ![6, 8, 12].contains(diff);
  }

  static bool _rajjuPoru(int s1, int s2) {
    const rajju = [0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1];
    return rajju[s1 % 27] != rajju[s2 % 27];
  }

  static bool _vedhaPoru(int s1, int s2) {
    const pairs = [[0,18],[1,16],[2,15],[3,13],[4,11],[5,10],[6,8],[7,24],[9,23],[12,22],[14,21],[17,26],[19,25]];
    for (final p in pairs) {
      if ((p[0]==s1&&p[1]==s2)||(p[1]==s1&&p[0]==s2)) return false;
    }
    return true;
  }

  static bool _vasyaPoru(int s1, int s2) {
    // Simplified: not 6th or 8th from each other
    final diff = (s2 - s1 + 27) % 27;
    return diff != 6 && diff != 8;
  }

  static bool _nadiPoru(int s1, int s2) {
    // Different nadi is good
    const nadi = [0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2];
    return nadi[s1 % 27] != nadi[s2 % 27];
  }

  static int poruthamScore(Map<String, bool> results) {
    return results.values.where((v) => v).length;
  }

  // ── Helper methods ─────────────────────────────────────────────────────────

  static ({String start, String end}) _slotTimes(String sr, String ss, int slotIdx) {
    final srF = _hm(sr); final ssF = _hm(ss);
    final dur = (ssF - srF) / 8;
    return (start: _fh(srF + (slotIdx - 1) * dur), end: _fh(srF + slotIdx * dur));
  }

  static double _hm(String hm) {
    final parts = hm.split(':');
    return int.parse(parts[0]) + int.parse(parts[1]) / 60.0;
  }

  static String _fh(double f) {
    f = f % 24;
    if (f < 0) f += 24;
    final h = f.floor();
    final m = ((f - h) * 60).round();
    final hh = m == 60 ? (h + 1) % 24 : h;
    final mm = m == 60 ? 0 : m;
    return '${hh.toString().padLeft(2,'0')}:${mm.toString().padLeft(2,'0')}';
  }
}
