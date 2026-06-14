import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';

final _rasipalanProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final now = DateTime.now();
  return DatabaseHelper.instance.getRasipalanMonthly(now.year, now.month);
});

class RasipalanScreen extends ConsumerStatefulWidget {
  const RasipalanScreen({super.key});
  @override
  ConsumerState<RasipalanScreen> createState() => _RasipalanScreenState();
}

class _RasipalanScreenState extends ConsumerState<RasipalanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final rasiAsync = ref.watch(_rasipalanProvider);
    final now = DateTime.now();
    
    const monthsTa = ['','ஜனவரி','பிப்ரவரி','மார்ச்','ஏப்ரல்','மே','ஜூன்','ஜூலை','ஆகஸ்ட்','செப்டம்பர்','அக்டோபர்','நவம்பர்','டிசம்பர்'];
    final isTa = AppLocale.isTa(context);
    final monthDisplay = isTa 
        ? monthsTa[now.month]
        : AppLocale.englishMonthsFull[now.month];

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          AppLocale.s(context, 'horoscope_title'),
                          style: const TextStyle(color: Colors.white70, fontSize: 10,
                              fontFamily: 'NotoSansTamil'),
                        ),
                      ),
                      Text(
                        '$monthDisplay ${now.year}',
                        style: const TextStyle(color: Colors.white, fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ),
                  TabBar(
                    controller: _tabs,
                    indicatorColor: Colors.white,
                    indicatorWeight: 2,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 12,
                        fontWeight: FontWeight.w600),
                    tabs: [
                      Tab(text: AppLocale.s(context, 'tab_day')),
                      Tab(text: AppLocale.s(context, 'tab_week')),
                      Tab(text: AppLocale.s(context, 'tab_month_tab')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                // Daily — from DB
                rasiAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(child: Text(AppLocale.s(context, 'no_data'))),
                  data: (list) => _RasiList(
                    list: list, colors: colors, expandedIndex: _expandedIndex,
                    onTap: (i) => setState(() => _expandedIndex = _expandedIndex == i ? null : i),
                  ),
                ),
                // Weekly — static sample
                _RasiList(
                  list: _weeklyData(context), colors: colors, expandedIndex: _expandedIndex,
                  onTap: (i) => setState(() => _expandedIndex = _expandedIndex == i ? null : i),
                ),
                // Monthly — same data
                rasiAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(child: Text(AppLocale.s(context, 'no_data'))),
                  data: (list) => _RasiList(
                    list: list, colors: colors, expandedIndex: _expandedIndex,
                    onTap: (i) => setState(() => _expandedIndex = _expandedIndex == i ? null : i),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _weeklyData(BuildContext context) {
    final isTa = AppLocale.isTa(context);
    return List.generate(12, (i) => {
      'rasi_index': i,
      'rasi_name_ta': isTa ? AppLocale.rasiNamesTa[i] : AppLocale.rasiNamesEn[i],
      'prediction_ta': AppLocale.s(context, 'weekly_prediction_all'),
      'lucky_color_ta': isTa ? 'சிவப்பு' : 'Red',
      'lucky_number': i + 1,
      'rating': 3 + (i % 3),
    });
  }
}

class _RasiList extends StatelessWidget {
  final List<Map<String, dynamic>> list;
  final KaalakkaniColors colors;
  final int? expandedIndex;
  final void Function(int) onTap;

  static const _rasiIcons = ['♈','♉','♊','♋','♌','♍','♎','♏','♐','♑','♒','♓'];

  const _RasiList({required this.list, required this.colors,
      required this.expandedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTa = AppLocale.isTa(context);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final r = list[i];
        final idx = r['rasi_index'] as int;
        final rating = r['rating'] as int? ?? 3;
        final isExpanded = expandedIndex == i;
        final rasiName = AppLocale.rasiName(context, idx);

        return GestureDetector(
          onTap: () => onTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isExpanded
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Theme.of(context).dividerColor,
                width: isExpanded ? 1.5 : 0.5,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Row(
                    children: [
                      // Rasi icon
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: colors.card2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(_rasiIcons[idx],
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rasiName,
                                style: const TextStyle(
                                    fontFamily: 'NotoSansTamil', fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            if (!isExpanded) ...[
                              Builder(
                                builder: (context) {
                                  final predText = AppLocale.translatePrediction(context, r['prediction_ta'] as String? ?? '');
                                  return Text(
                                    predText.length > 40
                                        ? '${predText.substring(0, 40)}...'
                                        : predText,
                                    style: TextStyle(
                                      fontFamily: 'NotoSansTamil',
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Star rating
                      Row(
                        children: List.generate(5, (s) => Icon(
                          s < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 14,
                          color: s < rating ? const Color(0xFFD4890A) : Colors.grey,
                        )),
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocale.translatePrediction(context, r['prediction_ta'] as String? ?? ''),
                          style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 12, height: 1.7),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _InfoChip(
                              label: AppLocale.s(context, 'lucky_color'),
                              value: AppLocale.translateColor(context, r['lucky_color_ta'] as String? ?? ''),
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              label: AppLocale.s(context, 'lucky_num'),
                              value: '${r['lucky_number'] ?? ''}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label, value;
  const _InfoChip({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<KaalakkaniColors>()?.card2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ',
              style: TextStyle(fontSize: 10, fontFamily: 'NotoSansTamil',
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
          Text(value, style: const TextStyle(fontSize: 11,
              fontFamily: 'NotoSansTamil', fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
