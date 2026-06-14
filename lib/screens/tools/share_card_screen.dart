import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/localization.dart';
import '../../data/database_helper.dart';
import 'package:intl/intl.dart';

class ShareCardScreen extends StatefulWidget {
  const ShareCardScreen({super.key});

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  PanchangamDay? _today;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final day = await DatabaseHelper.instance.getDay(DateTime.now());
    setState(() => _today = day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_share_card')),
        centerTitle: true,
      ),
      body: _today == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Preview card
                  _PanchangamCard(day: _today!, theme: theme),
                  const SizedBox(height: 24),
                  Text(
                    AppLocale.s(context, 'share_card_subtitle'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.share),
                    label: Text(AppLocale.s(context, 'share_btn'), style: const TextStyle(fontSize: 16)),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(200, 52),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _share() {
    if (_today == null) return;
    final d = _today!;
    final isTa = AppLocale.isTa(context);
    final String text;

    if (isTa) {
      text = '''📅 இன்றைய பஞ்சாங்கம் — ${DateFormat('dd-MM-yyyy').format(DateTime.now())}

🗓 தமிழ் தேதி: ${d.tamilYear} ${d.tamilMonth}
📆 வாரம்: ${d.weekdayTa}
🌙 திதி: ${d.thithiTa} (${d.thithiPaksha})
⭐ நட்சத்திரம்: ${d.nakshatraTa}

✅ நல்ல நேரம்: ${d.nallaNeramStart} – ${d.nallaNeramEnd}
❌ ராகு காலம்: ${d.rahukaalamStart} – ${d.rahukaalamEnd}

— காலக்கணிப்பயன்பாடு 📲''';
    } else {
      final engMonth = AppLocale.tamilMonthName(context, d.tamilMonth);
      final engThithi = '${d.thithiPaksha == 'சுக்ல' ? 'Shukla' : 'Krishna'} ${d.thithiEn}';
      final engStar = d.nakshatraEn;
      text = '''📅 Today's Panchangam — ${DateFormat('dd-MM-yyyy').format(DateTime.now())}

🗓 Tamil Date: ${d.tamilYear} $engMonth
📆 Weekday: ${AppLocale.weekdaysEn[d.weekday]}
🌙 Thithi: $engThithi
⭐ Nakshatra: $engStar

✅ Nalla Neram: ${d.nallaNeramStart} – ${d.nallaNeramEnd}
❌ Rahu Kaalam: ${d.rahukaalamStart} – ${d.rahukaalamEnd}

— Kaalakkani App 📲''';
    }

    Share.share(text, subject: AppLocale.s(context, 'share_subject'));
  }
}

class _PanchangamCard extends StatelessWidget {
  final PanchangamDay day;
  final ThemeData theme;

  const _PanchangamCard({required this.day, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isTa = AppLocale.isTa(context);
    final monthDisplay = AppLocale.tamilMonthName(context, day.tamilMonth);
    final weekdayDisplay = isTa ? day.weekdayTa : AppLocale.weekdaysEn[day.weekday];
    final thithiDisplay = isTa 
        ? '${day.thithiTa} (${day.thithiPaksha})' 
        : '${day.thithiPaksha == 'சுக்ல' ? 'Shukla' : 'Krishna'} ${day.thithiEn}';
    final starDisplay = isTa ? day.nakshatraTa : day.nakshatraEn;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC4520F),
            Color(0xFF9E3F08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC4520F).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTa ? 'காலக்கணி' : 'Kaalakkani',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                DateFormat('dd-MM-yyyy').format(DateTime.now()),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${day.tamilYear} $monthDisplay',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            weekdayDisplay,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Divider(color: Colors.white24, height: 24),
          _cardRow(AppLocale.s(context, 'thithi'), thithiDisplay),
          _cardRow(AppLocale.s(context, 'nakshatra'), starDisplay),
          _cardRow(AppLocale.s(context, 'yoga'), AppLocale.translateYoga(context, day.yogaTa)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Text('✅ ', style: TextStyle(fontSize: 18)),
                Text(
                  '${AppLocale.s(context, 'nalla_neram')}: ${day.nallaNeramStart} – ${day.nallaNeramEnd}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Text('❌ ', style: TextStyle(fontSize: 18)),
                Text(
                  '${AppLocale.s(context, 'rahukaalam')}: ${day.rahukaalamStart} – ${day.rahukaalamEnd}',
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 14.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 14.5)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.5)),
          ),
        ],
      ),
    );
  }
}
