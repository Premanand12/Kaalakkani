import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';

class MuhurthamScreen extends ConsumerStatefulWidget {
  const MuhurthamScreen({super.key});
  @override
  ConsumerState<MuhurthamScreen> createState() => _MuhurthamScreenState();
}

class _MuhurthamScreenState extends ConsumerState<MuhurthamScreen> {
  String _selectedEvent = 'திருமணம்';
  DateTimeRange _range = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 90)),
  );
  List<PanchangamDay>? _results;
  bool _loading = false;

  static const _events = [
    'திருமணம்', 'கிரஹப்பிரவேசம்', 'வாகன வாங்குதல்', 'கடை திறப்பு',
    'தொண்டில் சேர்தல்', 'குழந்தை நாமகரணம்', 'காது குத்துதல்', 'திரோட்டில்',
    'அன்னப்பிரசனம்',
  ];

  Future<void> _search() async {
    setState(() { _loading = true; _results = null; });
    final days = await DatabaseHelper.instance.getMuhurthamDays(
      from: _range.start, to: _range.end, eventType: _selectedEvent,
    );
    setState(() { _results = days; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFFC4520F),
            foregroundColor: Colors.white,
            pinned: true,
            title: Text(
              AppLocale.s(context, 'muhurtham_search_title'),
              style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 16.5, fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event type selector
                  Text(
                    AppLocale.s(context, 'select_event_type'),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansTamil',
                      color: cs.onSurface.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _events.map((e) => GestureDetector(
                      onTap: () => setState(() => _selectedEvent = e),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedEvent == e ? const Color(0xFFC4520F) : colors.card2,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedEvent == e
                                ? const Color(0xFFC4520F)
                                : cs.onSurface.withOpacity(0.15),
                            width: _selectedEvent == e ? 1.5 : 0.5,
                          ),
                        ),
                        child: Text(
                          AppLocale.translateMuhurthamEvent(context, e),
                          style: TextStyle(
                            fontFamily: 'NotoSansTamil',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedEvent == e ? Colors.white : cs.onSurface,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Date range picker
                  Text(
                    AppLocale.s(context, 'select_date_range'),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansTamil',
                      color: cs.onSurface.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                        initialDateRange: _range,
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: cs.copyWith(primary: const Color(0xFFC4520F)),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) setState(() => _range = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.card2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.onSurface.withOpacity(0.15), width: 0.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range, color: Color(0xFFC4520F), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            _fmtDate(_range.start),
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 15.0),
                          ),
                          const Text('  →  ', style: TextStyle(fontSize: 15.0)),
                          Text(
                            _fmtDate(_range.end),
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4520F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _loading
                          ? const SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              AppLocale.s(context, 'search_muhurtham_btn'),
                              style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 15.5,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Results
          if (_results != null)
            _results!.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        AppLocale.s(context, 'no_muhurtham_found'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NotoSansTamil',
                          fontSize: 14.5,
                          color: cs.onSurface.withOpacity(0.55),
                        ),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _MuhurthamCard(day: _results![i], rank: i + 1, colors: colors),
                    childCount: _results!.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
}

class _MuhurthamCard extends StatelessWidget {
  final PanchangamDay day;
  final int rank;
  final KaalakkaniColors colors;

  const _MuhurthamCard({required this.day, required this.rank, required this.colors});

  int get _score {
    int s = 5;
    if (day.isFasting) s -= 2;
    if (day.isKari) s -= 3;
    if (day.weekday == 1 || day.weekday == 5) s += 1; // Mon, Fri
    if ([2,3,5,6,7,10,12,13].contains(day.thithiIndex)) s += 1;
    return s.clamp(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const engMonths = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final parts = day.date.split('-');
    final dateDisp = '${engMonths[int.parse(parts[1])]} ${parts[2]}, ${parts[0]}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withOpacity(0.08), width: 0.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: colors.warnBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text('$rank',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                          color: colors.warn)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateDisp,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    AppLocale.isTa(context) ? day.weekdayTa : AppLocale.weekdaysEn[day.weekday],
                    style: TextStyle(fontFamily: 'NotoSansTamil', fontSize: 13.0,
                        color: cs.onSurface.withOpacity(0.55)),
                  ),
                ],
              ),
              const Spacer(),
              // Score dots
              Row(
                children: List.generate(5, (i) => Container(
                  width: 12, height: 5, margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    color: i < (_score / 2).ceil()
                        ? const Color(0xFFC4520F)
                        : cs.onSurface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6, runSpacing: 5,
            children: [
              _Tag(
                label: AppLocale.isTa(context)
                    ? '${day.thithiPaksha} ${day.thithiTa}'
                    : '${day.thithiPaksha == 'சுக்ல' ? 'Shukla' : 'Krishna'} ${day.thithiEn}',
                color: colors.good,
              ),
              _Tag(
                label: AppLocale.isTa(context) ? day.nakshatraTa : day.nakshatraEn,
                color: colors.info,
              ),
              _Tag(
                label: '${day.nallaNeramStart}–${day.nallaNeramEnd}',
                color: colors.warn,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.5, fontFamily: 'NotoSansTamil',
            fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
