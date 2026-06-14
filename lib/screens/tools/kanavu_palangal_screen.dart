import 'package:flutter/material.dart';
import '../../core/localization.dart';

class _Dream {
  final String symbolTa, symbolEn;
  final String meaningTa, meaningEn;
  final String resultTa, resultEn;
  const _Dream(this.symbolTa, this.symbolEn, this.meaningTa, this.meaningEn, this.resultTa, this.resultEn);
}

class KanavuPalangalScreen extends StatefulWidget {
  const KanavuPalangalScreen({super.key});

  @override
  State<KanavuPalangalScreen> createState() => _KanavuPalangalScreenState();
}

class _KanavuPalangalScreenState extends State<KanavuPalangalScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const List<_Dream> _dreams = [
    _Dream('பாம்பு', 'Snake', 'கனவில் பாம்பு கடிப்பது', 'Being bitten by a snake', 'எதிரிகளால் தொல்லை வரும். எச்சரிக்கை தேவை.', 'Troubles from enemies. Caution is required.'),
    _Dream('பாம்பு', 'Snake', 'பாம்பு சுற்றி வருவது', 'Snake wrapping around', 'செல்வம் வரும். நல்ல சகுனம்.', 'Wealth is coming. Good omen.'),
    _Dream('பாம்பு', 'Snake', 'பாம்பை கொல்வது', 'Killing a snake', 'எதிரி வெற்றி. நன்மை உண்டாகும்.', 'Victory over enemies. Good fortunes.'),
    _Dream('பசு', 'Cow', 'பசு கனவில் வருவது', 'Cow appearing in dream', 'செழிப்பும் நலமும் உண்டாகும்.', 'Prosperity and well-being will follow.'),
    _Dream('யானை', 'Elephant', 'யானை மேல் ஏறுவது', 'Riding an elephant', 'பதவி உயர்வு கிடைக்கும்.', 'Promotion and honor are coming.'),
    _Dream('யானை', 'Elephant', 'யானை துரத்துவது', 'Elephant chasing you', 'கஷ்டங்கள் வரலாம். ஜாக்கிரதை.', 'Obstacles/troubles ahead. Be careful.'),
    _Dream('குரங்கு', 'Monkey', 'குரங்கு கனவில் வருவது', 'Monkey in dream', 'நட்புகளால் நன்மை கிடைக்கும்.', 'Benefits from friends.'),
    _Dream('நாய்', 'Dog', 'நாய் கடிப்பது', 'Dog biting', 'நண்பர்களால் மோசம் வரும்.', 'Betrayal from friends.'),
    _Dream('நாய்', 'Dog', 'நாய் வால் ஆட்டுவது', 'Dog wagging its tail', 'நண்பர்களால் நன்மை வரும்.', 'Help from loyal friends.'),
    _Dream('பூனை', 'Cat', 'பூனை கனவில் வருவது', 'Cat in dream', 'வீட்டில் சச்சரவு வரலாம்.', 'Family disputes may arise.'),
    _Dream('மான்', 'Deer', 'மான் கனவில் வருவது', 'Deer in dream', 'வெற்றியும் புகழும் கிடைக்கும்.', 'Success and fame will follow.'),
    _Dream('புலி', 'Tiger', 'புலி துரத்துவது', 'Tiger chasing you', 'முதுகு தண்டு வடத்தில் வலிமை.', 'A strong adversary may confront you.'),
    _Dream('புலி', 'Tiger', 'புலியை அடிப்பது', 'Striking a tiger', 'எதிரிகளை வெல்வீர்கள்.', 'You will defeat your opponents.'),
    _Dream('சிங்கம்', 'Lion', 'சிங்கம் கனவில் வருவது', 'Lion in dream', 'அரசு மரியாதை கிடைக்கும்.', 'Government/official honors.'),
    _Dream('தேனீ', 'Bee', 'தேனீ கொட்டுவது', 'Bee stinging', 'நோய் வரலாம்.', 'Minor health issues.'),
    _Dream('தேன்', 'Honey', 'தேன் குடிப்பது', 'Drinking honey', 'செல்வம் வரும். இனிப்பான நேரம்.', 'Wealth flow. Sweet times ahead.'),
    _Dream('மீன்', 'Fish', 'மீன் பிடிப்பது', 'Catching fish', 'பணம் வரும். வியாபார லாபம்.', 'Financial gains and business profit.'),
    _Dream('மீன்', 'Fish', 'மீன் நீரில் நீந்துவது', 'Fish swimming in water', 'உங்கள் ஆசைகள் நிறைவேறும்.', 'Your desires will be fulfilled.'),
    _Dream('பறவை', 'Bird', 'பறவை பறப்பது', 'Bird flying', 'நல்ல செய்தி வரும்.', 'Good news is arriving.'),
    _Dream('பறவை', 'Bird', 'கருப்பு பறவை வருவது', 'Black bird appearing', 'கஷ்டம் வரலாம்.', 'Difficulties ahead.'),
    _Dream('கோழி', 'Rooster', 'கோழி கூவுவது', 'Rooster crowing', 'நல்ல காலம் வரும்.', 'Good times are coming.'),
    _Dream('ஆடு', 'Goat', 'ஆடு கனவில் வருவது', 'Goat in dream', 'குடும்ப மகிழ்ச்சி உண்டாகும்.', 'Family happiness.'),
    _Dream('குதிரை', 'Horse', 'குதிரை மேல் ஏறுவது', 'Riding a horse', 'வெற்றியும் மகிழ்ச்சியும் கிடைக்கும்.', 'Success and joy will be achieved.'),
    _Dream('குதிரை', 'Horse', 'குதிரை விழுவது', 'Horse falling', 'திட்டங்கள் தடைப்படலாம்.', 'Plans might face hurdles.'),
    _Dream('ஆறு', 'River', 'ஆற்றில் நீந்துவது', 'Swimming in a river', 'வாழ்க்கை தடையற்று செல்லும்.', 'Life will flow smoothly.'),
    _Dream('ஆறு', 'River', 'ஆறு வெள்ளம் வருவது', 'River flooding', 'திடீர் ஆபத்து. ஜாக்கிரதை.', 'Sudden danger. Be alert.'),
    _Dream('கடல்', 'Sea', 'கடலில் மூழ்குவது', 'Drowning in the sea', 'கஷ்டங்கள் நிறைந்த நேரம்.', 'Challenging times ahead.'),
    _Dream('கடல்', 'Sea', 'கடல் அலை வருவது', 'Sea waves rising', 'பெரிய மாற்றம் வரும்.', 'Significant changes are coming.'),
    _Dream('மழை', 'Rain', 'மழையில் நனைவது', 'Getting drenched in rain', 'சுகமான காலம் வரும்.', 'Pleasant days ahead.'),
    _Dream('தீ', 'Fire', 'தீ வீட்டை எரிப்பது', 'Fire burning a house', 'கஷ்டங்கள் வரலாம். உஷார்.', 'Difficulties may arise. Be cautious.'),
    _Dream('தீ', 'Fire', 'தீயில் கைகளை வைப்பது', 'Putting hands in fire', 'நோய் வரலாம்.', 'Health concerns.'),
    _Dream('தீ', 'Fire', 'தீ அணைவது', 'Fire going out', 'வாழ்க்கையில் தடை வரும்.', 'Hurdles in life.'),
    _Dream('தங்கம்', 'Gold', 'தங்கம் கிடைப்பது', 'Finding gold', 'செல்வம் மற்றும் வெற்றி வரும்.', 'Wealth and success.'),
    _Dream('தங்கம்', 'Gold', 'தங்கம் இழப்பது', 'Losing gold', 'நஷ்டம் வரலாம்.', 'Financial loss.'),
    _Dream('வெள்ளி', 'Silver', 'வெள்ளி நகை', 'Silver jewelry', 'நல்ல மங்களம் உண்டாகும்.', 'Auspicious events will take place.'),
    _Dream('மரம்', 'Tree', 'பெரிய மரம் நிழல்', 'Large shady tree', 'குடும்ப பாதுகாப்பு நல்லது.', 'Excellent family protection.'),
    _Dream('மரம்', 'Tree', 'மரம் விழுவது', 'Tree falling', 'குடும்பத்தில் கஷ்டம் வரலாம்.', 'Family difficulties.'),
    _Dream('பழம்', 'Fruit', 'இனப்பான பழம் சாப்பிடுவது', 'Eating sweet fruit', 'மகிழ்ச்சியான செய்தி வரும்.', 'Happy news is coming.'),
    _Dream('பூ', 'Flower', 'பூக்கள் நிறைந்த தோட்டம்', 'Garden full of flowers', 'வாழ்க்கையில் மலர்ச்சி வரும்.', 'Life will blossom.'),
    _Dream('பூ', 'Flower', 'வாடிய பூக்கள்', 'Withered flowers', 'தொல்லைகள் வரலாம்.', 'Minor worries ahead.'),
    _Dream('சூரியன்', 'Sun', 'சூரியன் பிரகாசிப்பது', 'Sun shining brightly', 'புகழும் வெற்றியும் வரும்.', 'Fame and victory.'),
    _Dream('சூரியன்', 'Sun', 'சூரியன் மறைவது', 'Sun setting', 'கஷ்ட காலம் வரலாம்.', 'Challenging phase ahead.'),
    _Dream('சந்திரன்', 'Moon', 'நிலவு பிரகாசிப்பது', 'Moon shining', 'நல்ல காலம் வரும்.', 'Good times ahead.'),
    _Dream('நட்சத்திரம்', 'Star', 'நட்சத்திரங்கள் விழுவது', 'Falling stars', 'திடீர் மாற்றம் வரும்.', 'Sudden life shifts.'),
    _Dream('வீடு', 'House', 'புதிய வீட்டில் நுழைவது', 'Entering a new house', 'நல்ல மாற்றம் வரும்.', 'Positive changes.'),
    _Dream('வீடு', 'House', 'வீடு இடிவது', 'House collapsing', 'கஷ்டங்கள் வரலாம்.', 'Troubles ahead.'),
    _Dream('திருமணம்', 'Marriage', 'திருமணம் பார்ப்பது', 'Watching a marriage', 'சுபகாரியங்கள் நடக்கும்.', 'Auspicious events will happen.'),
    _Dream('குழந்தை', 'Child', 'குழந்தை கனவில் வருவது', 'Child in dream', 'சந்தோஷமான செய்தி வரும்.', 'Joyful news.'),
    _Dream('இறந்தவர்', 'Deceased', 'இறந்தவர் கனவில் வருவது', 'Deceased appearing', 'அவர்கள் ஆசியே. நல்லது நடக்கும்.', 'Their blessing. Good things will happen.'),
    _Dream('பல்', 'Tooth', 'பல் விழுவது', 'Tooth falling', 'உறவினர் பிரிவு வரலாம்.', 'Parting from relatives.'),
    _Dream('தலை முடி', 'Hair', 'முடி கொட்டுவது', 'Hair falling', 'கஷ்டங்கள் வரலாம்.', 'Difficulties ahead.'),
    _Dream('பணம்', 'Money', 'பணம் கிடைப்பது', 'Finding money', 'நல்ல காலம் வரும்.', 'Good times ahead.'),
    _Dream('பணம்', 'Money', 'பணம் இழப்பது', 'Losing money', 'ஜாக்கிரதையாக இருக்கவும்.', 'Be careful with spending.'),
    _Dream('பறக்கிறோம்', 'Flying', 'வானத்தில் பறப்பது', 'Flying in the sky', 'உயர் பதவியும் வெற்றியும் வரும்.', 'Promotion and success.'),
    _Dream('விழுகிறோம்', 'Falling', 'கீழே விழுவது', 'Falling down', 'தோல்வி வரலாம். உஷார்.', 'Failure risk. Be alert.'),
    _Dream('ஓட்டம்', 'Running', 'பயந்து ஓடுவது', 'Running in fear', 'சிக்கல்கள் வரலாம்.', 'Complications ahead.'),
    _Dream('கோவில்', 'Temple', 'கோவிலுக்கு போவது', 'Going to a temple', 'இறையருள் கிடைக்கும். நல்லது நடக்கும்.', 'Divine grace and good fortune.'),
    _Dream('தெய்வம்', 'Deity', 'தெய்வம் கனவில் வருவது', 'Deity appearing', 'மிக நல்ல சகுனம். ஆசி கிடைக்கும்.', 'Highly auspicious. Divine blessings.'),
    _Dream('புத்தகம்', 'Book', 'புத்தகம் படிப்பது', 'Reading a book', 'கலவியில் வெற்றி வரும்.', 'Success in studies/intellect.'),
    _Dream('தண்ணீர்', 'Water', 'தெளிந்த தண்ணீர் பருகுவது', 'Drinking clean water', 'உடல் நலம் சீராகும்.', 'Good health.'),
    _Dream('தண்ணீர்', 'Water', 'கலங்கிய தண்ணீர்', 'Muddy water', 'குழப்பமான நேரம் வரும்.', 'Confusing times ahead.'),
    _Dream('காடு', 'Forest', 'காட்டில் தொலைவது', 'Getting lost in forest', 'திகைப்பான நேரம் வரும்.', 'Astonishing/confusing phase.'),
  ];

  List<_Dream> get _filtered {
    if (_query.isEmpty) return _dreams;
    final q = _query.toLowerCase();
    return _dreams
        .where((d) =>
            d.symbolTa.contains(q) || 
            d.symbolEn.toLowerCase().contains(q) || 
            d.meaningTa.contains(q) ||
            d.meaningEn.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;
    final isTa = AppLocale.isTa(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_kanavu')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: AppLocale.s(context, 'search_dream_hint'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} ${AppLocale.s(context, 'dream_count_suffix')}',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final d = filtered[i];
                final symbol = isTa ? d.symbolTa : d.symbolEn;
                final meaning = isTa ? d.meaningTa : d.meaningEn;
                final result = isTa ? d.resultTa : d.resultEn;

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
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                symbol,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                meaning,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(result, style: const TextStyle(fontSize: 14, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
