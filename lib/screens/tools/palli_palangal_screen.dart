import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';
import '../../data/database_helper.dart';

final _palliProvider = FutureProvider<List<Map<String, dynamic>>>(
  (ref) => DatabaseHelper.instance.getPalliPalangal(),
);

class PalliPalangalScreen extends ConsumerWidget {
  const PalliPalangalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(_palliProvider);
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC4520F), foregroundColor: Colors.white,
        title: Text(AppLocale.s(context, 'tool_palli'), 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(AppLocale.s(context, 'no_data'))),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final p = list[i];
            
            final part = AppLocale.translatePalliBodyPart(context, p['body_part_ta'] ?? '');
            final time = AppLocale.translatePalliTime(context, p['time_period_ta'] ?? '');
            final gender = AppLocale.translatePalliGender(context, p['gender'] ?? '');
            final meaning = AppLocale.translatePalliMeaning(context, p['meaning_ta'] ?? '');

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$part · $time · $gender',
                          style: TextStyle(fontSize: 12.5,
                              color: cs.onSurface.withOpacity(0.55))),
                      const SizedBox(height: 6),
                      Text(meaning,
                          style: const TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
