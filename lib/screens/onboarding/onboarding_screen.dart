import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _panchangam = 'vakiya'; // vakiya | drik
  int? _selectedRasi;
  bool _elderMode = false;

  static const _rasiNames = [
    'மேஷம்','ரிஷபம்','மிதுனம்','கடகம்','சிம்மம்','கன்னி',
    'துலாம்','விருச்சிகம்','தனுசு','மகரம்','கும்பம்','மீனம்',
  ];
  static const _rasiIcons = ['♈','♉','♊','♋','♌','♍','♎','♏','♐','♑','♒','♓'];

  void _complete() {
    final box = Hive.box('settings');
    box.put('onboarded', true);
    box.put('panchangam_type', _panchangam);
    box.put('user_rasi', _selectedRasi ?? -1);
    box.put('elder_mode', _elderMode);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = Theme.of(context).extension<KaalakkaniColors>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                child: Column(
                  children: [
                    Text('🕉️', style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 12),
                    const Text('காலக்கணி',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                            fontFamily: 'NotoSansTamil',
                            color: Color(0xFFC4520F))),
                    const SizedBox(height: 6),
                    Text('உங்கள் பஞ்சாங்கம் · உள்நுழைவு இல்லை · தேவை இல்லை',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, fontFamily: 'NotoSansTamil',
                            color: cs.onSurface.withOpacity(0.55))),
                  ],
                ),
              ),

              // Panchangam type
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('பஞ்சாங்க முறை தேர்வு'),
                    const SizedBox(height: 10),
                    _ChoiceCard(
                      selected: _panchangam == 'vakiya',
                      onTap: () => setState(() => _panchangam = 'vakiya'),
                      title: 'வாக்கிய பஞ்சாங்கம்',
                      subtitle: 'பாம்பு பஞ்சாங்கம் · பாரம்பரிய முறை',
                      recommended: true,
                    ),
                    const SizedBox(height: 8),
                    _ChoiceCard(
                      selected: _panchangam == 'drik',
                      onTap: () => setState(() => _panchangam = 'drik'),
                      title: 'திரிக் பஞ்சாங்கம்',
                      subtitle: 'நாசா தரவு · துல்லியமான கணக்கீடு',
                      recommended: false,
                    ),
                    const SizedBox(height: 24),

                    // Rasi selection
                    _SectionLabel('உங்கள் ராசி (விரும்பினால்)'),
                    Text('சந்திராஷ்டமம் எச்சரிக்கை தனிப்பட்ட முறையில் காட்டப்படும்',
                        style: TextStyle(fontSize: 10, fontFamily: 'NotoSansTamil',
                            color: cs.onSurface.withOpacity(0.45))),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.6,
                      children: List.generate(12, (i) => GestureDetector(
                        onTap: () => setState(() => _selectedRasi = _selectedRasi == i ? null : i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: _selectedRasi == i
                                ? const Color(0xFFC4520F)
                                : colors.card2,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedRasi == i
                                  ? const Color(0xFFC4520F)
                                  : cs.onSurface.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_rasiIcons[i],
                                  style: const TextStyle(fontSize: 16)),
                              Text(_rasiNames[i],
                                  style: TextStyle(
                                      fontSize: 9, fontFamily: 'NotoSansTamil',
                                      fontWeight: FontWeight.w500,
                                      color: _selectedRasi == i ? Colors.white : cs.onSurface)),
                            ],
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),

                    // Elder mode
                    _SectionLabel('காட்சி அமைப்புகள்'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.card2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.onSurface.withOpacity(0.08), width: 0.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.text_increase, color: Color(0xFFC4520F)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('மூத்தோர் பயன்முறை',
                                    style: TextStyle(fontFamily: 'NotoSansTamil',
                                        fontSize: 13, fontWeight: FontWeight.w600)),
                                Text('எழுத்து அளவை 25% அதிகரிக்கும்',
                                    style: TextStyle(fontFamily: 'NotoSansTamil',
                                        fontSize: 10,
                                        color: cs.onSurface.withOpacity(0.5))),
                              ],
                            ),
                          ),
                          Switch(
                            value: _elderMode,
                            onChanged: (v) => setState(() => _elderMode = v),
                            activeColor: const Color(0xFFC4520F),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // CTA
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _complete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC4520F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('தொடங்கு →',
                            style: TextStyle(fontFamily: 'NotoSansTamil',
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text('உள்நுழைவு இல்லை · கணக்கு தேவை இல்லை',
                          style: TextStyle(fontSize: 10, fontFamily: 'NotoSansTamil',
                              color: cs.onSurface.withOpacity(0.35))),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              fontFamily: 'NotoSansTamil', letterSpacing: 0.05,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45))),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String title, subtitle;
  final bool recommended;
  const _ChoiceCard({required this.selected, required this.onTap,
      required this.title, required this.subtitle, required this.recommended});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFC4520F).withOpacity(0.08)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFC4520F) : cs.onSurface.withOpacity(0.1),
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: const TextStyle(fontFamily: 'NotoSansTamil',
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      if (recommended) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D8A4E).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('பரிந்துரை',
                              style: TextStyle(fontSize: 8, fontFamily: 'NotoSansTamil',
                                  color: Color(0xFF2D8A4E), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(fontFamily: 'NotoSansTamil', fontSize: 10,
                          color: cs.onSurface.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFFC4520F) : cs.onSurface.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC4520F), shape: BoxShape.circle),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
