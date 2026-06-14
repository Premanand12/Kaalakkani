import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';
import '../../engine/panchangam_engine.dart';

class NumerologyScreen extends StatefulWidget {
  const NumerologyScreen({super.key});
  @override
  State<NumerologyScreen> createState() => _NumerologyScreenState();
}

class _NumerologyScreenState extends State<NumerologyScreen> {
  final _nameCtrl = TextEditingController();
  DateTime? _dob;
  int? _nameNum, _lifeNum;

  static const _meaningsTa = {
    1: 'தலைவர் குணம். சுயமான சிந்தனை. முன்னேற்றம்.',
    2: 'சமரசம். ஒத்துழைப்பு. உணர்வு ரீதியான ஆழம்.',
    3: 'படைப்பாற்றல். வெளிப்படையான தன்மை. மகிழ்ச்சி.',
    4: 'உழைப்பு. நேர்மை. நிலைத்தன்மை.',
    5: 'சுதந்திரம். சாகசம். மாற்றம் விரும்பும் தன்மை.',
    6: 'பொறுப்பு. குடும்ப அன்பு. சேவை மனம்.',
    7: 'ஆன்மிகம். ஆராய்ச்சி மனம். தனிமை விரும்புதல்.',
    8: 'வெற்றி. பொருளாதார திறன். அதிகார குணம்.',
    9: 'மனிதாபிமானம். கொடை குணம். உலகளாவிய சிந்தனை.',
  };

  static const _meaningsEn = {
    1: 'Leadership qualities. Independent thinking. Progress.',
    2: 'Diplomacy. Cooperation. Emotional depth.',
    3: 'Creativity. Expressive nature. Joy.',
    4: 'Hard work. Honesty. Stability.',
    5: 'Freedom. Adventure. Welcomes change.',
    6: 'Responsibility. Family love. Service mind.',
    7: 'Spirituality. Research mind. Enjoys solitude.',
    8: 'Success. Financial capability. Authoritative traits.',
    9: 'Humanitarianism. Generosity. Global thinking.',
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;
    final cs = Theme.of(context).colorScheme;
    final isTa = AppLocale.isTa(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_numerology').replaceAll('\n', ' ')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Label(AppLocale.s(context, 'your_name_label')),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Example: MURUGAN',
                hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.35)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            _Label(AppLocale.s(context, 'dob_label')),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1990),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                        colorScheme: cs.copyWith(primary: Theme.of(context).colorScheme.primary)),
                    child: child!,
                  ),
                );
                if (d != null) setState(() => _dob = d);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: cs.onSurface.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 10),
                    Text(_dob == null ? AppLocale.s(context, 'select_date_btn') :
                        '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                        style: const TextStyle(fontSize: 14.5)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _nameNum = _nameCtrl.text.isNotEmpty
                        ? PanchangamEngine.numerologyNumber(_nameCtrl.text) : null;
                    _lifeNum = _dob != null
                        ? PanchangamEngine.lifePathNumber(_dob!) : null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(AppLocale.s(context, 'calculate_numerology'), 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            if (_nameNum != null || _lifeNum != null) ...[
              const SizedBox(height: 24),
              if (_nameNum != null)
                _NumCard(
                  label: AppLocale.s(context, 'name_num_label'), 
                  number: _nameNum!, 
                  meaning: isTa ? (_meaningsTa[_nameNum!] ?? '') : (_meaningsEn[_nameNum!] ?? ''), 
                  colors: colors
                ),
              const SizedBox(height: 12),
              if (_lifeNum != null)
                _NumCard(
                  label: AppLocale.s(context, 'life_path_num_label'), 
                  number: _lifeNum!, 
                  meaning: isTa ? (_meaningsTa[_lifeNum!] ?? '') : (_meaningsEn[_lifeNum!] ?? ''), 
                  colors: colors
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)));
}

class _NumCard extends StatelessWidget {
  final String label, meaning;
  final int number;
  final KaalakkaniColors colors;
  const _NumCard({required this.label, required this.number,
      required this.meaning, required this.colors});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text('$number',
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
              const SizedBox(height: 4),
              Text(meaning, style: const TextStyle(fontSize: 14, height: 1.5)),
            ],
          )),
        ],
      ),
    );
  }
}
