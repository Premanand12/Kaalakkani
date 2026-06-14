import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';
import '../../data/live_data_service.dart';
import '../../widgets/festival_banner.dart';

// StateProvider to track the date currently being viewed
final homeDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Providers adapted to load Panchangam & Festivals dynamically for the selected date
final homePanchangamProvider = FutureProvider.family<PanchangamDay?, DateTime>((ref, date) async {
  return DatabaseHelper.instance.getDay(date);
});

final homeFestivalsProvider = FutureProvider.family<List<Festival>, DateTime>((ref, date) async {
  return DatabaseHelper.instance.getFestivalsForDate(date);
});

final homeKuralProvider = FutureProvider.family<Map<String, dynamic>?, DateTime>((ref, date) async {
  return DatabaseHelper.instance.getKuralOfDay(date);
});

final livePricesProvider = FutureProvider<LivePrices>((ref) async {
  return LiveDataService.instance.fetchPrices();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(homeDateProvider);
    final panchangamAsync = ref.watch(homePanchangamProvider(currentDate));
    final festivalsAsync = ref.watch(homeFestivalsProvider(currentDate));
    final kuralAsync = ref.watch(homeKuralProvider(currentDate));
    final pricesAsync = ref.watch(livePricesProvider);
    
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final isTa = AppLocale.isTa(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'app_title')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.today_outlined),
            onPressed: () {
              ref.read(homeDateProvider.notifier).state = DateTime.now();
            },
            tooltip: isTa ? 'இன்றைய தேதி' : 'Today\'s Date',
          )
        ],
      ),
      body: Column(
        children: [
          // ── Date Navigator Bar ───────────────────────────────────────────
          _buildDateNavigator(context, ref, currentDate),
          
          Expanded(
            child: panchangamAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text(isTa ? 'பஞ்சாங்கம் ஏற்ற முடியவில்லை: $e' : 'Could not load Panchangam: $e')),
              data: (day) {
                if (day == null) {
                  return Center(child: Text(isTa ? 'தேதி பஞ்சாங்கம் கிடைக்கவில்லை' : 'No Panchangam for this date'));
                }
                return festivalsAsync.when(
                  loading: () => _buildBody(context, day, [], kuralAsync, pricesAsync, colors),
                  error: (_, __) => _buildBody(context, day, [], kuralAsync, pricesAsync, colors),
                  data: (festivals) => _buildBody(context, day, festivals, kuralAsync, pricesAsync, colors),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Date Navigator Row ────────────────────────────────────────────────────
  Widget _buildDateNavigator(BuildContext context, WidgetRef ref, DateTime currentDate) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () {
              ref.read(homeDateProvider.notifier).update((date) => date.subtract(const Duration(days: 1)));
            },
          ),
          TextButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).colorScheme.primary,
                        onPrimary: Colors.white,
                        onSurface: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                ref.read(homeDateProvider.notifier).state = picked;
              }
            },
            icon: Icon(Icons.calendar_today_outlined, size: 14, color: Theme.of(context).colorScheme.primary),
            label: Text(
              _formatDate(context, currentDate),
              style: TextStyle(
                fontFamily: 'NotoSansTamil',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: () {
              ref.read(homeDateProvider.notifier).update((date) => date.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime d) {
    if (AppLocale.isTa(context)) {
      const weekdays = ['திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி', 'ஞாயிறு'];
      const monthsTa = ['ஜனவரி', 'பிப்ரவரி', 'மார்ச்', 'ஏப்ரல்', 'மே', 'ஜூன்', 'ஜூலை', 'ஆகஸ்ட்', 'செப்டம்பர்', 'அக்டோபர்', 'நவம்பர்', 'டிசம்பர்'];
      return '${weekdays[d.weekday - 1]}, ${monthsTa[d.month - 1]} ${d.day}, ${d.year}';
    } else {
      const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      const monthsEn = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      return '${weekdays[d.weekday - 1]}, ${monthsEn[d.month - 1]} ${d.day}, ${d.year}';
    }
  }

  // ── Home View Body ────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, PanchangamDay day, List<Festival> festivals,
      AsyncValue<Map<String, dynamic>?> kuralAsync, AsyncValue<LivePrices> pricesAsync, KaalakkaniColors colors) {
    final bannerType = festivals.isNotEmpty ? festivals.first.bannerType : 'normal';
    final isTa = AppLocale.isTa(context);
    final festivalName = festivals.isNotEmpty 
        ? (isTa ? festivals.first.nameTa : festivals.first.nameEn) 
        : null;

    final translatedPanchangam = _translatePanchangamDay(context, day);

    return CustomScrollView(
      slivers: [
        // ── Animated festival banner ────────────────────────────────────────
        SliverToBoxAdapter(
          child: FestivalBanner(
            day: translatedPanchangam,
            bannerType: bannerType,
            festivalName: festivalName,
          ),
        ),

        // ── Dynamic Alerts/Badges Row (Chandrashtamam, fasting, etc.) ──────
        SliverToBoxAdapter(
          child: _buildAlertsRow(context, day, colors),
        ),

        // ── Live prices card ticker ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildPricesCard(context, pricesAsync, colors),
        ),

        // ── Chronological Timelines Card ────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildTimelineCard(context, day, colors),
        ),

        // ── Panchangam 5 elements ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: _Section(
            title: AppLocale.s(context, 'panchangam_details'),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  children: [
                    _PRow(label: AppLocale.s(context, 'thithi'),
                        value: isTa 
                            ? '${day.thithiPaksha} ${day.thithiTa}'
                            : '${day.thithiPaksha == 'சுக்ல' ? 'Shukla' : 'Krishna'} ${day.thithiEn}',
                        subValue: isTa ? '${day.thithiEnd} வரை' : 'until ${day.thithiEnd}',
                        valueColor: colors.good),
                    _PRow(label: AppLocale.s(context, 'nakshatra'),
                        value: isTa ? day.nakshatraTa : day.nakshatraEn,
                        subValue: isTa ? '${day.nakshatraEnd} வரை' : 'until ${day.nakshatraEnd}',
                        valueColor: colors.info),
                    _PRow(label: AppLocale.s(context, 'yoga'),
                        value: AppLocale.translateYoga(context, day.yogaTa)),
                    _PRow(label: AppLocale.s(context, 'karanam'),
                        value: AppLocale.translateKaranam(context, day.karanamTa)),
                    _PRow(label: AppLocale.s(context, 'weekday'),
                        value: isTa ? day.weekdayTa : AppLocale.weekdaysEn[day.weekday]),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Soolam & Direction Warnings ─────────────────────────────────────
        SliverToBoxAdapter(
          child: _Section(
            title: AppLocale.s(context, 'soolam_melnokku'),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  children: [
                    _PRow(label: AppLocale.s(context, 'soolam_direction'),
                        value: isTa ? day.soolamDirection : _translateDirection(day.soolamDirection),
                        subValue: '${AppLocale.s(context, 'remedy')}: ${isTa ? day.soolamRemedy : _translateRemedy(day.soolamRemedy)}',
                        valueColor: colors.warn),
                    _PRow(label: AppLocale.s(context, 'melnokku_day'),
                        value: day.melnokku ? AppLocale.s(context, 'yes') : AppLocale.s(context, 'no'),
                        valueColor: day.melnokku ? colors.good : colors.bad),
                    _PRow(label: AppLocale.s(context, 'chandrashtamam'),
                        value: AppLocale.translateRasiString(context, day.chandrashtamamRasi),
                        valueColor: colors.warn),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Thirukkural of the Day ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildKuralCard(context, kuralAsync),
        ),

        // ── Planetary positions ────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _Section(
            title: AppLocale.s(context, 'planets_title'),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              padding: const EdgeInsets.all(0),
              children: [
                _PlanetChip(planet: isTa ? 'சூரியன்' : 'Sun', rasi: AppLocale.translateRasiString(context, day.sunRasi)),
                _PlanetChip(planet: isTa ? 'சந்திரன்' : 'Moon', rasi: AppLocale.translateRasiString(context, day.moonRasi)),
                _PlanetChip(planet: isTa ? 'குரு' : 'Jupiter', rasi: AppLocale.translateRasiString(context, day.jupiterRasi)),
                _PlanetChip(planet: isTa ? 'சனி' : 'Saturn', rasi: AppLocale.translateRasiString(context, day.saturnRasi)),
              ],
            ),
          ),
        ),

        // ── Sun/Moon times ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _Section(
            title: AppLocale.s(context, 'sun_moon_title'),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  children: [
                    _PRow(label: AppLocale.s(context, 'sunrise'), value: day.sunrise, valueColor: colors.warn),
                    _PRow(label: AppLocale.s(context, 'sunset'), value: day.sunset, valueColor: colors.warn),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  // Translates direction strings for Soolam
  String _translateDirection(String dir) {
    const map = {'தெற்கு': 'South', 'கிழக்கு': 'East', 'வடக்கு': 'North', 'மேற்கு': 'West'};
    return map[dir] ?? dir;
  }

  // Translates remedy names for Soolam
  String _translateRemedy(String rem) {
    const map = {'நல்லெண்ணெய்': 'Sesame Oil', 'தயிர்': 'Curd', 'பால்': 'Milk', 'வெல்லம்': 'Jaggery'};
    return map[rem] ?? rem;
  }

  // Translates PanchangamDay items specifically for passing to the FestivalBanner canvas
  PanchangamDay _translatePanchangamDay(BuildContext context, PanchangamDay d) {
    if (AppLocale.isTa(context)) return d;
    
    // Convert Tamil Month and Tamil Year names phonetically for English speakers
    final idx = AppLocale.monthsTa.indexOf(d.tamilMonth);
    final englishMonth = idx >= 0 ? AppLocale.monthsEn[idx] : d.tamilMonth;

    return PanchangamDay(
      date: d.date,
      weekday: d.weekday,
      weekdayTa: AppLocale.weekdaysEn[d.weekday],
      tamilMonth: englishMonth,
      tamilYear: d.tamilYear, // Keep Tamil cycle year names as they are (classical)
      sunrise: d.sunrise,
      sunset: d.sunset,
      thithiIndex: d.thithiIndex,
      thithiTa: d.thithiTa,
      thithiEn: d.thithiEn,
      thithiPaksha: d.thithiPaksha == 'சுக்ல' ? 'Shukla' : 'Krishna',
      thithiEnd: d.thithiEnd,
      nakshatraIndex: d.nakshatraIndex,
      nakshatraTa: d.nakshatraTa,
      nakshatraEn: d.nakshatraEn,
      nakshatraEnd: d.nakshatraEnd,
      yogaIndex: d.yogaIndex,
      yogaTa: d.yogaTa,
      karanamIndex: d.karanamIndex,
      karanamTa: d.karanamTa,
      nallaNeramStart: d.nallaNeramStart,
      nallaNeramEnd: d.nallaNeramEnd,
      rahukaalamStart: d.rahukaalamStart,
      rahukaalamEnd: d.rahukaalamEnd,
      yamakandamStart: d.yamakandamStart,
      yamakandamEnd: d.yamakandamEnd,
      kuligaiStart: d.kuligaiStart,
      kuligaiEnd: d.kuligaiEnd,
      gowriStart: d.gowriStart,
      gowriEnd: d.gowriEnd,
      varjyamStart: d.varjyamStart,
      varjyamEnd: d.varjyamEnd,
      abhijitStart: d.abhijitStart,
      abhijitEnd: d.abhijitEnd,
      soolamDirection: d.soolamDirection,
      soolamRemedy: d.soolamRemedy,
      sunRasi: d.sunRasi,
      moonRasi: d.moonRasi,
      jupiterRasi: d.jupiterRasi,
      saturnRasi: d.saturnRasi,
      chandrashtamamRasi: d.chandrashtamamRasi,
      isFasting: d.isFasting,
      isKari: d.isKari,
      isFestival: d.isFestival,
      isMuhurtham: d.isMuhurtham,
      melnokku: d.melnokku,
    );
  }

  // ── Dynamic Alerts/Badges Builder ─────────────────────────────────────────
  Widget _buildAlertsRow(BuildContext context, PanchangamDay day, KaalakkaniColors colors) {
    final settingsBox = Hive.box('settings');
    final userRasiIdx = settingsBox.get('user_rasi', defaultValue: -1) as int;
    final isTa = AppLocale.isTa(context);
    
    final userRasiName = userRasiIdx >= 0 && userRasiIdx < 12 ? AppLocale.rasiNamesTa[userRasiIdx] : '';
    final userRasiDisplay = userRasiIdx >= 0 && userRasiIdx < 12 ? AppLocale.rasiName(context, userRasiIdx) : '';
    
    final isChandrashtamam = userRasiName.isNotEmpty && (userRasiName == day.chandrashtamamRasi);

    final badges = <Widget>[];

    if (day.isMuhurtham) {
      badges.add(_alertBadge(AppLocale.s(context, 'muhurtham_day'), colors.warn, colors.warnBg));
    }
    if (day.isFasting) {
      badges.add(_alertBadge(AppLocale.s(context, 'fasting_day'), colors.good, colors.goodBg));
    }
    if (day.isKari) {
      badges.add(_alertBadge(AppLocale.s(context, 'kari_day'), colors.bad, colors.badBg));
    }
    if (day.isFestival) {
      badges.add(_alertBadge(AppLocale.s(context, 'fest_day'), colors.info, colors.infoBg));
    }

    return Column(
      children: [
        if (isChandrashtamam)
          Container(
            margin: const EdgeInsets.fromLTRB(14, 8, 14, 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.badBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.bad.withOpacity(0.5), width: 0.8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: colors.bad, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isTa 
                        ? 'சந்திராஷ்டமம் எச்சரிக்கை! உங்கள் ராசிக்கு ($userRasiDisplay) இன்று சந்திராஷ்டமம். புதிய காரியங்களைத் தவிர்க்கவும்.'
                        : 'Chandrashtamam Warning! Today is Chandrashtamam for your Rasi ($userRasiDisplay). Avoid starting new ventures.',
                    style: TextStyle(
                      fontFamily: 'NotoSansTamil',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.bad,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (badges.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: badges,
              ),
            ),
          ),
      ],
    );
  }

  Widget _alertBadge(String text, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withOpacity(0.2), width: 0.8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'NotoSansTamil',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  // ── Live Pricing Card Summary ─────────────────────────────────────────────
  Widget _buildPricesCard(BuildContext context, AsyncValue<LivePrices> pricesAsync, KaalakkaniColors colors) {
    final isTa = AppLocale.isTa(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart, color: Color(0xFFD4890A), size: 16),
                const SizedBox(width: 6),
                Text(
                  AppLocale.s(context, 'gold_price_title'),
                  style: const TextStyle(
                    fontFamily: 'NotoSansTamil',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            pricesAsync.when(
              loading: () => const Center(child: LinearProgressIndicator()),
              error: (err, stack) => Text(
                isTa ? 'விலை விவரம் பெற இயலவில்லை' : 'Price data unavailable',
                style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 10),
              ),
              data: (p) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _priceMiniItem(AppLocale.s(context, 'gold_22k') + ' (1g)', '₹${p.gold22k}', p.goldChange, colors, isTa),
                    _priceMiniItem(AppLocale.s(context, 'silver_1g'), '₹${p.silver}', 0, colors, isTa),
                    _priceMiniItem(AppLocale.s(context, 'petrol'), '₹${p.petrol}', 0, colors, isTa),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceMiniItem(String label, String price, double change, KaalakkaniColors colors, bool isTa) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontFamily: 'NotoSansTamil', color: Colors.grey)),
        const SizedBox(height: 3),
        Text(price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: Color(0xFFD4890A))),
        if (change != 0) ...[
          const SizedBox(height: 1),
          Text(
            change > 0 
                ? (isTa ? '+₹${change.abs()} இன்று' : '+₹${change.abs()} today')
                : (isTa ? '-₹${change.abs()} இன்று' : '-₹${change.abs()} today'),
            style: TextStyle(fontSize: 11, fontFamily: 'Inter', color: change > 0 ? colors.bad : colors.good),
          ),
        ]
      ],
    );
  }

  // ── Chronological Timelines Card ──────────────────────────────────────────
  Widget _buildTimelineCard(BuildContext context, PanchangamDay day, KaalakkaniColors colors) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_filled, color: Theme.of(context).colorScheme.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  AppLocale.s(context, 'timings_title'),
                  style: const TextStyle(
                    fontFamily: 'NotoSansTamil',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Auspicious
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _timelineSectionHeader(AppLocale.s(context, 'good_times'), colors.good),
                      const SizedBox(height: 6),
                      _timelineItem(AppLocale.s(context, 'nalla_neram'), '${day.nallaNeramStart} - ${day.nallaNeramEnd}', colors.good, colors.goodBg),
                      _timelineItem(AppLocale.s(context, 'gowri_nalla_neram'), '${day.gowriStart} - ${day.gowriEnd}', colors.good, colors.goodBg),
                      _timelineItem(AppLocale.s(context, 'abhijit'), '${day.abhijitStart} - ${day.abhijitEnd}', colors.good, colors.goodBg),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right Column: Inauspicious
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _timelineSectionHeader(AppLocale.s(context, 'bad_times'), colors.bad),
                      const SizedBox(height: 6),
                      _timelineItem(AppLocale.s(context, 'rahukaalam'), '${day.rahukaalamStart} - ${day.rahukaalamEnd}', colors.bad, colors.badBg),
                      _timelineItem(AppLocale.s(context, 'yamakandam'), '${day.yamakandamStart} - ${day.yamakandamEnd}', colors.warn, colors.warnBg),
                      _timelineItem(AppLocale.s(context, 'kuligai'), '${day.kuligaiStart} - ${day.kuligaiEnd}', colors.info, colors.infoBg),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineSectionHeader(String label, Color color) {
    return Row(
      children: [
        Container(width: 2.5, height: 10, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'NotoSansTamil',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _timelineItem(String label, String time, Color markerColor, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: markerColor, width: 2.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'NotoSansTamil',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: markerColor,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            time,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: markerColor.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  // ── Thirukkural of the Day ────────────────────────────────────────────────
  Widget _buildKuralCard(BuildContext context, AsyncValue<Map<String, dynamic>?> kuralAsync) {
    final cs = Theme.of(context).colorScheme;
    final isTa = AppLocale.isTa(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: Theme.of(context).colorScheme.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  AppLocale.s(context, 'kural_title'),
                  style: const TextStyle(
                    fontFamily: 'NotoSansTamil',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            kuralAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text(
                isTa ? 'குறள் விவரம் பெற இயலவில்லை' : 'Thirukkural details unavailable',
                style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 10),
              ),
              data: (k) {
                if (k == null) {
                  return Text(
                    isTa ? 'இன்று திருக்குறள் இல்லை' : 'No Thirukkural available today',
                    style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 10),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTa ? 'குறள் ${k['number']}:' : 'Kural ${k['number']}:',
                      style: TextStyle(
                        fontFamily: 'NotoSansTamil',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isTa ? (k['kural_ta'] as String) : (k['kural_en'] as String),
                      style: const TextStyle(
                        fontFamily: 'NotoSansTamil',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppLocale.s(context, 'kural_explanation') + ':',
                      style: const TextStyle(
                        fontFamily: 'NotoSansTamil',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      k['explanation_ta'] ?? k['kural_en'] ?? '',
                      style: TextStyle(
                        fontFamily: 'NotoSansTamil',
                        fontSize: 10,
                        color: cs.onSurface.withOpacity(0.65),
                        height: 1.3,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable section widget ──────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontFamily: 'NotoSansTamil', fontSize: 13,
                  fontWeight: FontWeight.w700, letterSpacing: 0.06)),
          const SizedBox(height: 6),
          child,
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ── Panchangam row ────────────────────────────────────────────────────────────
class _PRow extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Color? valueColor;
  const _PRow({required this.label, required this.value, this.subValue, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontFamily: 'NotoSansTamil', fontSize: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.55))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: TextStyle(
                      fontFamily: 'NotoSansTamil', fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? Theme.of(context).colorScheme.onSurface)),
              if (subValue != null)
                Text(subValue!,
                    style: TextStyle(
                        fontFamily: 'NotoSansTamil', fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45))),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Planet chip ───────────────────────────────────────────────────────────────
class _PlanetChip extends StatelessWidget {
  final String planet;
  final String rasi;
  const _PlanetChip({required this.planet, required this.rasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<KaalakkaniColors>()?.card2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05), width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Text(planet,
              style: TextStyle(fontFamily: 'NotoSansTamil', fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55))),
          const Spacer(),
          Text(rasi,
              style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
