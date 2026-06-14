import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';

class ThirukkuralScreen extends StatefulWidget {
  const ThirukkuralScreen({super.key});

  @override
  State<ThirukkuralScreen> createState() => _ThirukkuralScreenState();
}

class _ThirukkuralScreenState extends State<ThirukkuralScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _allKurals = [];
  List<Map<String, dynamic>> _filtered = [];
  Map<String, dynamic>? _dailyKural;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _loadKurals();
  }

  Future<void> _loadKurals() async {
    final all = await DatabaseHelper.instance.db.query('thirukkural', orderBy: 'number');
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays + 1;
    final dailyIndex = (dayOfYear - 1) % (all.isEmpty ? 1 : all.length);

    setState(() {
      _allKurals = all;
      _filtered = all;
      _dailyKural = all.isEmpty ? null : all[dailyIndex];
      _loading = false;
    });
  }

  void _search(String q) {
    setState(() {
      if (q.isEmpty) {
        _filtered = _allKurals;
      } else {
        _filtered = _allKurals
            .where((k) =>
                (k['kural_ta'] as String? ?? '').contains(q) ||
                (k['adhigaram_ta'] as String? ?? '').contains(q) ||
                (k['adhigaram_en'] as String? ?? '').toLowerCase().contains(q.toLowerCase()) ||
                (k['kural_en'] as String? ?? '').toLowerCase().contains(q.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_thirukkural')),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(child: Text(AppLocale.s(context, 'tab_kural_today'), style: const TextStyle(fontSize: 14))),
            Tab(child: Text(AppLocale.s(context, 'tab_kural_all'), style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _DailyKuralTab(kural: _dailyKural, theme: theme),
                _AllKuralsTab(
                  kurals: _filtered,
                  searchCtrl: _searchCtrl,
                  onSearch: _search,
                  theme: theme,
                ),
              ],
            ),
    );
  }
}

class _DailyKuralTab extends StatelessWidget {
  final Map<String, dynamic>? kural;
  final ThemeData theme;

  const _DailyKuralTab({required this.kural, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isTa = AppLocale.isTa(context);
    if (kural == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(AppLocale.s(context, 'kural_db_err')),
          ],
        ),
      );
    }

    final primaryText = isTa
        ? (kural!['kural_ta'] as String? ?? '')
        : (kural!['kural_en'] as String? ?? '');
    final secondaryText = isTa
        ? (kural!['kural_en'] as String? ?? '')
        : (kural!['kural_ta'] as String? ?? '');
    final adhigaram = isTa
        ? (kural!['adhigaram_ta'] ?? '')
        : (kural!['adhigaram_en'] ?? '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            AppLocale.s(context, 'kural_title'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocale.s(context, 'kural_num_prefix')} #${kural!['number']}',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              primaryText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                height: 1.8,
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (secondaryText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                secondaryText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15.5, height: 1.5),
              ),
            ),
          const SizedBox(height: 16),
          Chip(
            label: Text('${AppLocale.s(context, 'adhigaram_prefix')}: $adhigaram',
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
          if (isTa && (kural!['explanation_ta'] as String? ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${AppLocale.s(context, 'kural_explanation')}:',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              kural!['explanation_ta'] as String,
              style: TextStyle(fontSize: 14.5, color: theme.colorScheme.onSurface.withOpacity(0.75), height: 1.5),
            ),
          ]
        ],
      ),
    );
  }
}

class _AllKuralsTab extends StatelessWidget {
  final List<Map<String, dynamic>> kurals;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final ThemeData theme;

  const _AllKuralsTab({
    required this.kurals,
    required this.searchCtrl,
    required this.onSearch,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isTa = AppLocale.isTa(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchCtrl,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: AppLocale.s(context, 'kural_search_hint'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            onChanged: onSearch,
          ),
        ),
        Expanded(
          child: kurals.isEmpty
              ? Center(child: Text(AppLocale.s(context, 'no_kurals_found'), style: const TextStyle(fontSize: 15)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: kurals.length,
                  itemBuilder: (_, i) {
                    final k = kurals[i];
                    final adhigaram = isTa ? (k['adhigaram_ta'] ?? '') : (k['adhigaram_en'] ?? '');
                    final text = isTa ? (k['kural_ta'] ?? '') : (k['kural_en'] ?? '');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '#${k['number']}',
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  adhigaram,
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              text,
                              style: const TextStyle(
                                  fontSize: 15.5, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
