import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../engine/panchangam_engine.dart';

class PoruthamScreen extends StatefulWidget {
  const PoruthamScreen({super.key});
  @override
  State<PoruthamScreen> createState() => _PoruthamScreenState();
}

class _PoruthamScreenState extends State<PoruthamScreen> {
  int? _star1, _star2;
  Map<String, bool>? _result;

  void _calculate() {
    if (_star1 == null || _star2 == null) return;
    setState(() => _result = PanchangamEngine.porutham(_star1!, _star2!));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final cs = Theme.of(context).colorScheme;
    final score = _result != null ? PanchangamEngine.poruthamScore(_result!) : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_porutham').replaceAll('\n', ' ')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star selectors
            Row(
              children: [
                Expanded(child: _StarPicker(
                  label: AppLocale.s(context, 'groom_star'),
                  selected: _star1,
                  onSelect: (i) => setState(() => _star1 = i),
                )),
                const SizedBox(width: 12),
                Expanded(child: _StarPicker(
                  label: AppLocale.s(context, 'bride_star'),
                  selected: _star2,
                  onSelect: (i) => setState(() => _star2 = i),
                )),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(AppLocale.s(context, 'calculate_btn'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              // Score summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text('$score / 10 ${AppLocale.s(context, 'score_suffix')}',
                        style: const TextStyle(color: Colors.white, fontSize: 24,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      score >= 7 ? AppLocale.s(context, 'score_good') :
                      score >= 5 ? AppLocale.s(context, 'score_average') :
                      AppLocale.s(context, 'score_careful'),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Individual porutham results
              ..._result!.entries.map((e) => _PoruthamRow(
                name: e.key,
                passes: e.value,
                colors: colors,
              )),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.infoBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.info.withOpacity(0.3), width: 0.5),
                ),
                child: Text(
                  AppLocale.s(context, 'porutham_note'),
                  style: TextStyle(fontSize: 12, color: colors.info, height: 1.5),
                ),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _StarPicker extends StatelessWidget {
  final String label;
  final int? selected;
  final void Function(int) onSelect;
  const _StarPicker({required this.label, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
            color: cs.onSurface.withOpacity(0.6))),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selected,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.onSurface.withOpacity(0.15), width: 0.5),
            ),
          ),
          hint: Text(AppLocale.s(context, 'select_hint'),
              style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.4))),
          items: List.generate(27, (i) => DropdownMenuItem(
            value: i,
            child: Text(AppLocale.starName(context, i),
                style: const TextStyle(fontSize: 14)),
          )),
          onChanged: (v) { if (v != null) onSelect(v); },
        ),
      ],
    );
  }
}

class _PoruthamRow extends StatelessWidget {
  final String name;
  final bool passes;
  final KaalakkaniColors colors;
  const _PoruthamRow({required this.name, required this.passes, required this.colors});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(passes ? Icons.check_circle : Icons.cancel,
              color: passes ? colors.good : colors.bad, size: 22),
          const SizedBox(width: 12),
          Text(AppLocale.s(context, name),
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(passes ? AppLocale.s(context, 'matches_yes') : AppLocale.s(context, 'matches_no'),
              style: TextStyle(fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: passes ? colors.good : colors.bad)),
        ],
      ),
    );
  }
}
