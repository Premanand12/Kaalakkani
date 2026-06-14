import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Represents one day's complete Panchangam data
class PanchangamDay {
  final String date;
  final int weekday;
  final String weekdayTa;
  final String tamilMonth;
  final String tamilYear;
  final String sunrise;
  final String sunset;
  final int thithiIndex;
  final String thithiTa;
  final String thithiEn;
  final String thithiPaksha;
  final String thithiEnd;
  final int nakshatraIndex;
  final String nakshatraTa;
  final String nakshatraEn;
  final String nakshatraEnd;
  final int yogaIndex;
  final String yogaTa;
  final int karanamIndex;
  final String karanamTa;
  final String nallaNeramStart;
  final String nallaNeramEnd;
  final String rahukaalamStart;
  final String rahukaalamEnd;
  final String yamakandamStart;
  final String yamakandamEnd;
  final String kuligaiStart;
  final String kuligaiEnd;
  final String gowriStart;
  final String gowriEnd;
  final String varjyamStart;
  final String varjyamEnd;
  final String abhijitStart;
  final String abhijitEnd;
  final String soolamDirection;
  final String soolamRemedy;
  final String sunRasi;
  final String moonRasi;
  final String jupiterRasi;
  final String saturnRasi;
  final String chandrashtamamRasi;
  final bool isFasting;
  final bool isKari;
  final bool isFestival;
  final bool isMuhurtham;
  final bool melnokku;

  const PanchangamDay({
    required this.date,
    required this.weekday,
    required this.weekdayTa,
    required this.tamilMonth,
    required this.tamilYear,
    required this.sunrise,
    required this.sunset,
    required this.thithiIndex,
    required this.thithiTa,
    required this.thithiEn,
    required this.thithiPaksha,
    required this.thithiEnd,
    required this.nakshatraIndex,
    required this.nakshatraTa,
    required this.nakshatraEn,
    required this.nakshatraEnd,
    required this.yogaIndex,
    required this.yogaTa,
    required this.karanamIndex,
    required this.karanamTa,
    required this.nallaNeramStart,
    required this.nallaNeramEnd,
    required this.rahukaalamStart,
    required this.rahukaalamEnd,
    required this.yamakandamStart,
    required this.yamakandamEnd,
    required this.kuligaiStart,
    required this.kuligaiEnd,
    required this.gowriStart,
    required this.gowriEnd,
    required this.varjyamStart,
    required this.varjyamEnd,
    required this.abhijitStart,
    required this.abhijitEnd,
    required this.soolamDirection,
    required this.soolamRemedy,
    required this.sunRasi,
    required this.moonRasi,
    required this.jupiterRasi,
    required this.saturnRasi,
    required this.chandrashtamamRasi,
    required this.isFasting,
    required this.isKari,
    required this.isFestival,
    required this.isMuhurtham,
    required this.melnokku,
  });

  factory PanchangamDay.fromMap(Map<String, dynamic> m) {
    return PanchangamDay(
      date: m['date'] as String,
      weekday: m['weekday'] as int,
      weekdayTa: m['weekday_ta'] as String,
      tamilMonth: m['tamil_month'] as String,
      tamilYear: m['tamil_year'] as String,
      sunrise: m['sunrise'] as String,
      sunset: m['sunset'] as String,
      thithiIndex: m['thithi_index'] as int,
      thithiTa: m['thithi_name_ta'] as String,
      thithiEn: m['thithi_name_en'] as String,
      thithiPaksha: m['thithi_paksha'] as String,
      thithiEnd: m['thithi_end'] as String,
      nakshatraIndex: m['nakshatra_index'] as int,
      nakshatraTa: m['nakshatra_name_ta'] as String,
      nakshatraEn: m['nakshatra_name_en'] as String,
      nakshatraEnd: m['nakshatra_end'] as String,
      yogaIndex: m['yoga_index'] as int,
      yogaTa: m['yoga_name_ta'] as String,
      karanamIndex: m['karanam_index'] as int,
      karanamTa: m['karanam_name_ta'] as String,
      nallaNeramStart: m['nalla_neram_start'] as String,
      nallaNeramEnd: m['nalla_neram_end'] as String,
      rahukaalamStart: m['rahukaalam_start'] as String,
      rahukaalamEnd: m['rahukaalam_end'] as String,
      yamakandamStart: m['yamagandam_start'] as String,
      yamakandamEnd: m['yamagandam_end'] as String,
      kuligaiStart: m['kuligai_start'] as String,
      kuligaiEnd: m['kuligai_end'] as String,
      gowriStart: m['gowri_start'] as String,
      gowriEnd: m['gowri_end'] as String,
      varjyamStart: m['varjyam_start'] as String,
      varjyamEnd: m['varjyam_end'] as String,
      abhijitStart: m['abhijit_start'] as String,
      abhijitEnd: m['abhijit_end'] as String,
      soolamDirection: m['soolam_direction'] as String,
      soolamRemedy: m['soolam_remedy'] as String,
      sunRasi: m['sun_rasi'] as String,
      moonRasi: m['moon_rasi'] as String,
      jupiterRasi: m['jupiter_rasi'] as String,
      saturnRasi: m['saturn_rasi'] as String,
      chandrashtamamRasi: m['chandrashtamam_rasi'] as String,
      isFasting: (m['is_fasting'] as int) == 1,
      isKari: (m['is_kari'] as int) == 1,
      isFestival: (m['is_festival'] as int) == 1,
      isMuhurtham: (m['is_muhurtham'] as int) == 1,
      melnokku: (m['melnokku'] as int) == 1,
    );
  }
}

class Festival {
  final String date;
  final String nameTa;
  final String nameEn;
  final String type;
  final String bannerType;
  final int importance;

  const Festival({
    required this.date, required this.nameTa, required this.nameEn,
    required this.type, required this.bannerType, required this.importance,
  });

  factory Festival.fromMap(Map<String, dynamic> m) => Festival(
    date: m['date'] as String,
    nameTa: m['name_ta'] as String,
    nameEn: m['name_en'] as String,
    type: m['type'] as String,
    bannerType: m['banner_type'] as String,
    importance: m['importance'] as int,
  );
}

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<void> init() async {
    if (_db != null) return;
    final docDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docDir.path, 'kaalakkani.db');

    // Copy from assets if not exists
    if (!File(dbPath).existsSync()) {
      final bytes = await rootBundle.load('assets/db/kaalakkani.db');
      await File(dbPath).writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }

    _db = await openDatabase(dbPath, readOnly: true);
  }

  Database get db {
    if (_db == null) throw StateError('DatabaseHelper not initialised. Call init() first.');
    return _db!;
  }

  // ── Panchangam queries ──────────────────────────────────────────────────

  Future<PanchangamDay?> getDay(DateTime date) async {
    final dateStr = _fmt(date);
    final rows = await db.query('panchangam', where: 'date = ?', whereArgs: [dateStr]);
    if (rows.isEmpty) return null;
    return PanchangamDay.fromMap(rows.first);
  }

  Future<List<PanchangamDay>> getMonth(int year, int month) async {
    final start = _fmt(DateTime(year, month, 1));
    final end   = _fmt(DateTime(year, month + 1, 0));
    final rows  = await db.query(
      'panchangam',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
      orderBy: 'date ASC',
    );
    return rows.map(PanchangamDay.fromMap).toList();
  }

  Future<List<PanchangamDay>> getMuhurthamDays({
    required DateTime from,
    required DateTime to,
    required String eventType,
  }) async {
    // Auspicious conditions vary by event — use a set of good Thithi + Nakshatra combos
    final goodThithi = [1, 2, 3, 5, 6, 7, 10, 12, 13]; // Dvitiya, Tritiya...
    final badNakshatra = [8, 9, 15, 16, 17, 18]; // Ashlesha, Magha, Swati...
    final thithiList = goodThithi.join(',');

    final rows = await db.rawQuery('''
      SELECT * FROM panchangam
      WHERE date >= ? AND date <= ?
        AND thithi_index IN ($thithiList)
        AND nakshatra_index NOT IN (${badNakshatra.join(',')})
        AND is_kari = 0
        AND weekday NOT IN (2, 6)
      ORDER BY date ASC
      LIMIT 30
    ''', [_fmt(from), _fmt(to)]);
    return rows.map(PanchangamDay.fromMap).toList();
  }

  // ── Festival queries ────────────────────────────────────────────────────

  Future<List<Festival>> getFestivalsForDate(DateTime date) async {
    final rows = await db.query('festivals', where: 'date = ?', whereArgs: [_fmt(date)]);
    return rows.map(Festival.fromMap).toList();
  }

  Future<List<Festival>> getFestivalsForMonth(int year, int month) async {
    final start = _fmt(DateTime(year, month, 1));
    final end   = _fmt(DateTime(year, month + 1, 0));
    final rows  = await db.query(
      'festivals',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
      orderBy: 'date ASC',
    );
    return rows.map(Festival.fromMap).toList();
  }

  // ── Thirukkural ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getKuralOfDay(DateTime date) async {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final kuralNum = (dayOfYear % 1330) + 1;
    final rows = await db.query('thirukkural', where: 'number = ?', whereArgs: [kuralNum]);
    return rows.isEmpty ? null : rows.first;
  }

  // ── Rasipalan ───────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getRasipalanMonthly(int year, int month) async {
    final rows = await db.query(
      'rasipalan_monthly',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
      orderBy: 'rasi_index ASC',
    );
    if (rows.isEmpty) {
      return db.query(
        'rasipalan_monthly',
        orderBy: 'rasi_index ASC',
      );
    }
    return rows;
  }

  // ── Baby names ──────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getBabyNames({
    int? nakshatraIndex,
    String? gender,
  }) async {
    String where = '1=1';
    List<dynamic> args = [];
    if (nakshatraIndex != null) { where += ' AND nakshatra_index = ?'; args.add(nakshatraIndex); }
    if (gender != null) { where += ' AND gender = ?'; args.add(gender); }
    return db.query('baby_names', where: where, whereArgs: args, orderBy: 'name_ta ASC');
  }

  // ── Palli palangal ──────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPalliPalangal({String? gender}) async {
    if (gender != null) {
      return db.query('palli_palangal', where: 'gender = ?', whereArgs: [gender], orderBy: 'body_part_ta ASC');
    }
    return db.query('palli_palangal', orderBy: 'body_part_ta ASC');
  }

  // ── Historical date search ──────────────────────────────────────────────

  Future<PanchangamDay?> getDayByTamilMonth(String tamilMonth, int year) async {
    final rows = await db.query(
      'panchangam',
      where: 'tamil_month = ? AND date LIKE ?',
      whereArgs: [tamilMonth, '$year%'],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return PanchangamDay.fromMap(rows.first);
  }

  // ── Utils ────────────────────────────────────────────────────────────────

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
}
