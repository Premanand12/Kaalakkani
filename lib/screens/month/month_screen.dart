import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';

final _monthProvider = FutureProvider.family<List<PanchangamDay>, (int, int)>((ref, ym) async {
  return DatabaseHelper.instance.getMonth(ym.$1, ym.$2);
});

final _festProvider = FutureProvider.family<List<Festival>, (int, int)>((ref, ym) async {
  return DatabaseHelper.instance.getFestivalsForMonth(ym.$1, ym.$2);
});

class MonthScreen extends ConsumerStatefulWidget {
  const MonthScreen({super.key});
  @override
  ConsumerState<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends ConsumerState<MonthScreen> {
  DateTime _viewing = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ym = (_viewing.year, _viewing.month);
    final days = ref.watch(_monthProvider(ym));
    final fests = ref.watch(_festProvider(ym));
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final cs = Theme.of(context).colorScheme;
    final isTa = AppLocale.isTa(context);

    final tamilMonths = ['சித்திரை','வைகாசி','ஆனி','ஆடி','ஆவணி','புரட்டாசி',
      'ஐப்பசி','கார்த்திகை','மார்கழி','தை','மாசி','பங்குனி'];
    final tamilIdx = (_viewing.month - 4) % 12;
    final tamilMonth = tamilMonths[tamilIdx];
    final translatedTamilMonth = AppLocale.tamilMonthName(context, tamilMonth);

    final weekdayHeaders = isTa 
        ? ['ஞா','தி','செ','பு','வி','வெ','ச']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    final headerSubText = isTa
        ? '${AppLocale.englishMonths[_viewing.month]} ${_viewing.year}'
        : '${AppLocale.englishMonthsFull[_viewing.month]} ${_viewing.year}';

    return Scaffold(
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                      onPressed: () => setState(() {
                        _viewing = DateTime(_viewing.year, _viewing.month - 1);
                      }),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(translatedTamilMonth,
                              style: const TextStyle(color: Colors.white70, fontSize: 11,
                                  fontWeight: FontWeight.w500, fontFamily: 'NotoSansTamil')),
                          const SizedBox(height: 2),
                          Text(headerSubText,
                              style: const TextStyle(color: Colors.white, fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                      onPressed: () => setState(() {
                        _viewing = DateTime(_viewing.year, _viewing.month + 1);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Legend ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Legend(color: colors.good, label: AppLocale.s(context, 'legend_festival')),
                const SizedBox(width: 24),
                _Legend(color: colors.bad, label: AppLocale.s(context, 'legend_fasting')),
                const SizedBox(width: 24),
                _Legend(color: colors.warn, label: AppLocale.s(context, 'legend_muhurtham')),
              ],
            ),
          ),

          // ── Weekday headers ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: weekdayHeaders
                  .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              fontFamily: 'NotoSansTamil',
                              color: cs.onSurface.withOpacity(0.45))),
                    ),
                  ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),

          // ── Calendar grid ─────────────────────────────────────────────────
          days.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: LinearProgressIndicator(),
            ),
            error: (_, __) => const SizedBox(),
            data: (dayList) {
              final festMap = <String, Festival>{};
              fests.whenData((fl) {
                for (final f in fl) festMap[f.date] = f;
              });
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _CalendarGrid(
                  year: _viewing.year,
                  month: _viewing.month,
                  days: dayList,
                  festivals: festMap,
                  colors: colors,
                ),
              );
            },
          ),
          
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocale.s(context, 'month_festivals'),
                style: TextStyle(
                  fontFamily: 'NotoSansTamil',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface.withOpacity(0.45),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // ── Event list ────────────────────────────────────────────────────
          Expanded(
            child: fests.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
              data: (fl) => fl.isEmpty
                  ? Center(
                      child: Text(
                        AppLocale.s(context, 'no_festivals'),
                        style: TextStyle(fontFamily: 'NotoSansTamil', fontSize: 11,
                            color: cs.onSurface.withOpacity(0.4)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 2, 14, 80),
                      itemCount: fl.length,
                      itemBuilder: (_, i) {
                        final f = fl[i];
                        final d = f.date.split('-');
                        final day = d[2];
                        final displayMonth = AppLocale.englishMonths[int.parse(d[1])];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: f.type == 'harvest' || f.type == 'hindu'
                                    ? colors.goodBg
                                    : f.type == 'government'
                                        ? colors.infoBg
                                        : colors.warnBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    color: f.type == 'harvest' || f.type == 'hindu'
                                        ? colors.good
                                        : f.type == 'government'
                                            ? colors.info
                                            : colors.warn,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              isTa ? f.nameTa : f.nameEn,
                              style: const TextStyle(
                                fontFamily: 'NotoSansTamil',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '$displayMonth - ${isTa ? f.nameEn : f.nameTa}',
                              style: TextStyle(
                                fontSize: 10,
                                color: cs.onSurface.withOpacity(0.45),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final int year, month;
  final List<PanchangamDay> days;
  final Map<String, Festival> festivals;
  final KaalakkaniColors colors;

  const _CalendarGrid({
    required this.year, required this.month,
    required this.days, required this.festivals, required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDay = DateTime(year, month, 1);
    final startOffset = firstDay.weekday % 7; // 0=Sun
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final cs = Theme.of(context).colorScheme;

    final dayMap = <int, PanchangamDay>{};
    for (final d in days) dayMap[int.parse(d.date.split('-')[2])] = d;

    final cells = <Widget>[];
    for (int i = 0; i < startOffset; i++) cells.add(const SizedBox());

    for (int d = 1; d <= daysInMonth; d++) {
      final dateStr = '$year-${month.toString().padLeft(2,'0')}-${d.toString().padLeft(2,'0')}';
      final day = dayMap[d];
      final fest = festivals[dateStr];
      final isToday = today.year == year && today.month == month && today.day == d;

      Color? bg;
      Color numColor = cs.onSurface;
      if (fest != null) {
        bg = colors.goodBg;
        numColor = colors.good;
      } else if (day?.isFasting == true) {
        bg = colors.badBg;
        numColor = colors.bad;
      } else if (day?.isMuhurtham == true) {
        bg = colors.warnBg;
        numColor = colors.warn;
      }

      cells.add(
        Container(
          margin: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            color: bg ?? colors.card2.withOpacity(0.35),
            borderRadius: BorderRadius.circular(10),
            border: isToday
                ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)
                : Border.all(color: Colors.transparent),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  '$d',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                    color: isToday ? Theme.of(context).colorScheme.primary : numColor,
                  ),
                ),
              ),
              if (fest != null)
                Positioned(
                  bottom: 3,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 3.5, height: 3.5,
                      decoration: BoxDecoration(color: colors.good, shape: BoxShape.circle),
                    ),
                  ),
                )
              else if (day?.isFasting == true)
                Positioned(
                  bottom: 3,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 3.5, height: 3.5,
                      decoration: BoxDecoration(color: colors.bad, shape: BoxShape.circle),
                    ),
                  ),
                )
              else if (day?.isMuhurtham == true)
                Positioned(
                  bottom: 3,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 3.5, height: 3.5,
                      decoration: BoxDecoration(color: colors.warn, shape: BoxShape.circle),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.05,
      children: cells,
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2.5))),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, fontFamily: 'NotoSansTamil',
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55))),
      ],
    );
  }
}
