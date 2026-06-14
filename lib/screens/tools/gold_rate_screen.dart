import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../data/live_data_service.dart';
import '../../core/theme.dart';

class GoldRateScreen extends StatefulWidget {
  const GoldRateScreen({super.key});
  @override
  State<GoldRateScreen> createState() => _GoldRateScreenState();
}

class _GoldRateScreenState extends State<GoldRateScreen> {
  LivePrices? _prices;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await LiveDataService.instance.fetchPrices();
      if (mounted) setState(() { _prices = p; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC4520F), foregroundColor: Colors.white,
        title: Text(AppLocale.s(context, 'tool_gold'), 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _prices == null
            ? Center(child: Text(AppLocale.s(context, 'rate_not_found')))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _BigPriceCard(label: AppLocale.s(context, 'gold_22k_label'), perGram: _prices!.gold22k,
                        perSovereign: _prices!.gold22k * 8, change: _prices!.goldChange, colors: colors),
                    const SizedBox(height: 12),
                    _BigPriceCard(label: AppLocale.s(context, 'gold_24k_label'), perGram: _prices!.gold24k,
                        perSovereign: _prices!.gold24k * 8, change: 0, colors: colors),
                    const SizedBox(height: 12),
                    _BigPriceCard(label: AppLocale.s(context, 'silver_label'), perGram: _prices!.silver,
                        perSovereign: _prices!.silver * 8, change: 0, colors: colors),
                    const Spacer(),
                    Text('${AppLocale.s(context, 'last_updated_label')}: ${_prices!.updatedAt}',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35))),
                  ],
                ),
            ),
    );
  }
}

class _BigPriceCard extends StatelessWidget {
  final String label;
  final double perGram, perSovereign, change;
  final KaalakkaniColors colors;
  const _BigPriceCard({required this.label, required this.perGram,
      required this.perSovereign, required this.change, required this.colors});
  @override
  Widget build(BuildContext context) {
    final isTa = AppLocale.isTa(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocale.s(context, 'one_gram'), style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('₹${perGram.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Inter', color: Color(0xFFD4890A))),
                ],
              )),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocale.s(context, 'one_sovereign'), style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('₹${perSovereign.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Inter', color: Color(0xFFD4890A))),
                ],
              )),
            ],
          ),
          if (change != 0) ...[
            const SizedBox(height: 8),
            Text(
                change > 0 
                    ? '↑ +₹${change.abs()} ${AppLocale.s(context, 'rate_today')}' 
                    : '↓ -₹${change.abs()} ${AppLocale.s(context, 'rate_today')}',
                style: TextStyle(fontSize: 13,
                    color: change > 0 ? colors.bad : colors.good, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}
