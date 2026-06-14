import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';

final _namesProvider = FutureProvider.family<List<Map<String, dynamic>>, (int?, String?)>(
  (ref, args) => DatabaseHelper.instance.getBabyNames(nakshatraIndex: args.$1, gender: args.$2),
);

class BabyNamesScreen extends ConsumerStatefulWidget {
  const BabyNamesScreen({super.key});
  @override
  ConsumerState<BabyNamesScreen> createState() => _BabyNamesScreenState();
}

class _BabyNamesScreenState extends ConsumerState<BabyNamesScreen> {
  int? _star;
  String? _gender;

  @override
  Widget build(BuildContext context) {
    final names = ref.watch(_namesProvider((_star, _gender)));
    final cs = Theme.of(context).colorScheme;
    final isTa = AppLocale.isTa(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_baby_names').replaceAll('\n', ' ')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _star,
                    decoration: InputDecoration(
                      labelText: AppLocale.s(context, 'filter_star'),
                      labelStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null, 
                        child: Text(AppLocale.s(context, 'all_filter'), style: const TextStyle(fontSize: 14))
                      ),
                      ...List.generate(27, (i) => DropdownMenuItem(
                        value: i,
                        child: Text(AppLocale.starName(context, i), style: const TextStyle(fontSize: 14))
                      ))
                    ],
                    onChanged: (v) => setState(() => _star = v),
                  ),
                ),
                const SizedBox(width: 10),
                SegmentedButton<String?>(
                  segments: [
                    ButtonSegment(
                      value: null, 
                      label: Text(AppLocale.s(context, 'gender_all'), style: const TextStyle(fontSize: 12))
                    ),
                    ButtonSegment(
                      value: 'M', 
                      label: Text(AppLocale.s(context, 'gender_male'), style: const TextStyle(fontSize: 12))
                    ),
                    ButtonSegment(
                      value: 'F', 
                      label: Text(AppLocale.s(context, 'gender_female'), style: const TextStyle(fontSize: 12))
                    ),
                  ],
                  selected: {_gender},
                  onSelectionChanged: (s) => setState(() => _gender = s.first),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) =>
                      states.contains(WidgetState.selected) ? Theme.of(context).colorScheme.primary : null),
                    foregroundColor: WidgetStateProperty.resolveWith((states) =>
                      states.contains(WidgetState.selected) ? Colors.white : null),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: names.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(AppLocale.s(context, 'no_data'))),
              data: (list) => list.isEmpty
                  ? Center(child: Text(AppLocale.s(context, 'no_names_found'), 
                      style: TextStyle(fontSize: 15, color: cs.onSurface.withOpacity(0.4))))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final n = list[i];
                        final rawName = n['name_ta'] as String;
                        final displayName = isTa ? rawName : AppLocale.transliterate(rawName);
                        final rawMeaning = n['name_meaning_ta'] as String;
                        final displayMeaning = rawMeaning; // Meaning is Tamil only, we present it.

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          leading: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: (n['gender'] == 'M')
                                  ? const Color(0xFF1A6FAF).withOpacity(0.15)
                                  : const Color(0xFFD4537E).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text(
                              n['gender'] == 'M' ? '♂' : '♀',
                              style: TextStyle(fontSize: 20, color: n['gender'] == 'M'
                                  ? const Color(0xFF1A6FAF) : const Color(0xFFD4537E)),
                            )),
                          ),
                          title: Text(displayName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(displayMeaning,
                                  style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.55))),
                              Text(
                                  isTa 
                                      ? 'தொடக்க எழுத்து: ${n['starting_letter'] ?? ''}'
                                      : 'Starting Letter: ${n['starting_letter'] ?? ''}',
                                  style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.35))),
                            ],
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
