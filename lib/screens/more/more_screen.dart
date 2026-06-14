import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../data/live_data_service.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  LivePrices? _prices;
  bool _loadingPrices = true;

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    try {
      final p = await LiveDataService.instance.fetchPrices();
      if (mounted) setState(() { _prices = p; _loadingPrices = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingPrices = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final cs = Theme.of(context).colorScheme;
    final isTa = AppLocale.isTa(context);

    final tools = [
      (route: '/porutham',   icon: Icons.favorite_outline, label: AppLocale.s(context, 'tool_porutham')),
      (route: '/baby-names', icon: Icons.child_care_outlined, label: AppLocale.s(context, 'tool_baby_names')),
      (route: '/palli',      icon: Icons.bug_report_outlined, label: AppLocale.s(context, 'tool_palli')),
      (route: '/numerology', icon: Icons.calculate_outlined, label: AppLocale.s(context, 'tool_numerology')),
      (route: '/moi',        icon: Icons.currency_rupee, label: AppLocale.s(context, 'tool_moi')),
      (route: '/gold',       icon: Icons.diamond_outlined, label: AppLocale.s(context, 'tool_gold')),
      (route: '/thirukkural',   icon: Icons.menu_book_outlined, label: AppLocale.s(context, 'tool_thirukkural')),
      (route: '/family-stars',  icon: Icons.people_outline, label: AppLocale.s(context, 'tool_family_stars')),
      (route: '/share-card',    icon: Icons.share_outlined, label: AppLocale.s(context, 'tool_share_card')),
      (route: '/kanavu',        icon: Icons.cloud_outlined, label: AppLocale.s(context, 'tool_kanavu')),
      (route: '/date-converter',icon: Icons.swap_horiz, label: AppLocale.s(context, 'tool_date_converter')),
      (route: '/settings',      icon: Icons.settings_outlined, label: AppLocale.s(context, 'tool_settings')),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: cs.background,
            foregroundColor: cs.onSurface,
            title: Text(
              AppLocale.s(context, 'more_app_bar'),
              style: const TextStyle(fontFamily: 'NotoSansTamil', fontSize: 16.5, fontWeight: FontWeight.bold),
            ),
            pinned: true,
          ),

          // ── Live prices ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(AppLocale.s(context, 'gold_price_title')),
                  const SizedBox(height: 8),
                  _loadingPrices
                    ? const LinearProgressIndicator()
                    : _prices == null
                      ? Text(
                          AppLocale.s(context, 'rate_not_found'),
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'NotoSansTamil',
                            color: cs.onSurface.withOpacity(0.4),
                          ),
                        )
                      : Column(
                          children: [
                            _PriceRow(
                              emoji: '💛',
                              label: AppLocale.s(context, 'gold_22k'),
                              value: '₹${_prices!.gold22k}',
                              change: _prices!.goldChange,
                              colors: colors,
                            ),
                            _PriceRow(
                              emoji: '🩶',
                              label: AppLocale.s(context, 'silver_1g'),
                              value: '₹${_prices!.silver}',
                              change: 0,
                              colors: colors,
                            ),
                            _PriceRow(
                              emoji: '⛽',
                              label: AppLocale.s(context, 'petrol_label'),
                              value: '₹${_prices!.petrol}',
                              change: 0,
                              colors: colors,
                            ),
                            _PriceRow(
                              emoji: '🔵',
                              label: AppLocale.s(context, 'diesel_label'),
                              value: '₹${_prices!.diesel}',
                              change: 0,
                              colors: colors,
                            ),
                            _PriceRow(
                              emoji: '🟡',
                              label: AppLocale.s(context, 'lpg_label'),
                              value: '₹${_prices!.lpg}',
                              change: _prices!.lpgChange,
                              colors: colors,
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  _SectionTitle(AppLocale.s(context, 'tools_sec')),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Tools grid ───────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final t = tools[i];
                  return GestureDetector(
                    onTap: () => context.push(t.route),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.card2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(t.icon, color: cs.primary, size: 26),
                          const SizedBox(height: 6),
                          Text(t.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'NotoSansTamil', fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: cs.onSurface, height: 1.4)),
                        ],
                      ),
                    ),
                  );
                },
                childCount: tools.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
            fontFamily: 'NotoSansTamil', letterSpacing: 0.05,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45)));
  }
}

class _PriceRow extends StatelessWidget {
  final String emoji, label, value;
  final double change;
  final KaalakkaniColors colors;
  const _PriceRow({required this.emoji, required this.label, required this.value,
      required this.change, required this.colors});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isTa = AppLocale.isTa(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, fontFamily: 'NotoSansTamil',
                    color: cs.onSurface)),
                if (change != 0)
                  Text(
                    change > 0 
                      ? (isTa ? '↑ +₹${change.abs()} இன்று' : '↑ +₹${change.abs()} today')
                      : (isTa ? '↓ -₹${change.abs()} இன்று' : '↓ -₹${change.abs()} today'),
                    style: TextStyle(fontSize: 9, fontFamily: 'NotoSansTamil',
                        color: change > 0 ? colors.good : colors.bad),
                  ),
              ],
            ),
          ),
          Text(value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  fontFamily: 'Inter', color: Color(0xFFD4890A))),
        ],
      ),
    );
  }
}
