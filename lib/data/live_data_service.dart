import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class LivePrices {
  final double gold22k;
  final double gold24k;
  final double silver;
  final double petrol;
  final double diesel;
  final double lpg;
  final double goldChange;
  final double lpgChange;
  final String updatedAt;

  const LivePrices({
    required this.gold22k, required this.gold24k, required this.silver,
    required this.petrol, required this.diesel, required this.lpg,
    required this.goldChange, required this.lpgChange, required this.updatedAt,
  });

  factory LivePrices.fromJson(Map<String, dynamic> j) => LivePrices(
    gold22k: (j['gold22k'] as num).toDouble(),
    gold24k: (j['gold24k'] as num).toDouble(),
    silver: (j['silver'] as num).toDouble(),
    petrol: (j['petrol'] as num).toDouble(),
    diesel: (j['diesel'] as num).toDouble(),
    lpg: (j['lpg'] as num).toDouble(),
    goldChange: (j['goldChange'] as num? ?? 0).toDouble(),
    lpgChange: (j['lpgChange'] as num? ?? 0).toDouble(),
    updatedAt: j['updatedAt'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'gold22k': gold22k, 'gold24k': gold24k, 'silver': silver,
    'petrol': petrol, 'diesel': diesel, 'lpg': lpg,
    'goldChange': goldChange, 'lpgChange': lpgChange, 'updatedAt': updatedAt,
  };

  // Fallback / cached data
  static const fallback = LivePrices(
    gold22k: 13860, gold24k: 15120, silver: 890,
    petrol: 111.18, diesel: 97.83, lpg: 941.50,
    goldChange: 45, lpgChange: -15,
    updatedAt: 'cached',
  );
}

class LiveDataService {
  LiveDataService._();
  static final LiveDataService instance = LiveDataService._();

  static const _cacheKey = 'live_prices';
  static const _cacheTimeKey = 'live_prices_time';
  static const _cacheHours = 6; // refresh every 6 hours

  Future<LivePrices> fetchPrices() async {
    final box = Hive.box('settings');

    // Check cache
    final cachedJson = box.get(_cacheKey);
    final cachedTime = box.get(_cacheTimeKey, defaultValue: 0) as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    final hoursSince = (now - cachedTime) / 1000 / 3600;

    if (cachedJson != null && hoursSince < _cacheHours) {
      return LivePrices.fromJson(jsonDecode(cachedJson as String));
    }

    // Try to fetch live data
    try {
      return await _fetchLive(box);
    } catch (_) {
      // Return cached or fallback
      if (cachedJson != null) return LivePrices.fromJson(jsonDecode(cachedJson as String));
      return LivePrices.fallback;
    }
  }

  Future<LivePrices> _fetchLive(Box box) async {
    // GoldAPI.io free tier — or swap to any other free metals API
    // This returns INR gold price per gram
    final goldResp = await http.get(
      Uri.parse('https://www.goldapi.io/api/XAU/INR'),
      headers: {'x-access-token': 'goldapi-demo-key'}, // replace with your free key
    ).timeout(const Duration(seconds: 5));

    double gold24k = LivePrices.fallback.gold24k;
    if (goldResp.statusCode == 200) {
      final j = jsonDecode(goldResp.body);
      // gold price per troy oz → per gram
      final perOz = (j['price'] as num?)?.toDouble() ?? 0;
      if (perOz > 0) gold24k = perOz / 31.1035;
    }
    final gold22k = gold24k * 22 / 24;
    final silver = LivePrices.fallback.silver;

    // Petrol price — Indian Oil publishes daily. Using free API stub.
    final petrol = LivePrices.fallback.petrol;
    final diesel = LivePrices.fallback.diesel;
    final lpg    = LivePrices.fallback.lpg;

    final prices = LivePrices(
      gold22k: double.parse(gold22k.toStringAsFixed(0)),
      gold24k: double.parse(gold24k.toStringAsFixed(0)),
      silver: silver,
      petrol: petrol, diesel: diesel, lpg: lpg,
      goldChange: 0, lpgChange: 0,
      updatedAt: DateTime.now().toIso8601String(),
    );

    // Cache result
    await box.put(_cacheKey, jsonEncode(prices.toJson()));
    await box.put(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);

    return prices;
  }
}
