import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/localization.dart';

class FamilyMember {
  final String name;
  final String nakshatraTa;
  final int nakshatraIndex;

  FamilyMember({
    required this.name,
    required this.nakshatraTa,
    required this.nakshatraIndex,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'nakshatra_ta': nakshatraTa,
        'nakshatra_index': nakshatraIndex,
      };

  factory FamilyMember.fromMap(Map m) => FamilyMember(
        name: m['name'] as String,
        nakshatraTa: m['nakshatra_ta'] as String,
        nakshatraIndex: m['nakshatra_index'] as int,
      );
}

class FamilyStarBookScreen extends StatefulWidget {
  const FamilyStarBookScreen({super.key});

  @override
  State<FamilyStarBookScreen> createState() => _FamilyStarBookScreenState();
}

class _FamilyStarBookScreenState extends State<FamilyStarBookScreen> {
  late Box _box;
  List<FamilyMember> _members = [];

  static const _nakshatras = [
    'அஸ்வினி', 'பரணி', 'கார்த்திகை', 'ரோஹிணி',
    'மிருகசீரிஷம்', 'திருவாதிரை', 'புனர்பூசம்', 'பூசம்',
    'ஆயில்யம்', 'மகம்', 'பூரம்', 'உத்திரம்',
    'ஹஸ்தம்', 'சித்திரை', 'சுவாதி', 'விசாகம்',
    'அனுஷம்', 'கேட்டை', 'மூலம்', 'பூராடம்',
    'உத்திராடம்', 'திருவோணம்', 'அவிட்டம்', 'சதயம்',
    'பூரட்டாதி', 'உத்தரட்டாதி', 'ரேவதி',
  ];

  @override
  void initState() {
    super.initState();
    _box = Hive.box('family_stars');
    _loadMembers();
  }

  void _loadMembers() {
    final raw = _box.get('members', defaultValue: []);
    _members = (raw as List)
        .map((e) => FamilyMember.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  void _saveMembers() {
    _box.put('members', _members.map((m) => m.toMap()).toList());
  }

  void _addMember() {
    final nameCtrl = TextEditingController();
    int selectedNakshatra = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(AppLocale.s(context, 'add_family_title')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  labelText: AppLocale.s(context, 'moi_name'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: AppLocale.s(context, 'filter_star'),
                  border: const OutlineInputBorder(),
                ),
                value: selectedNakshatra,
                items: List.generate(
                  _nakshatras.length,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(AppLocale.starName(context, i)),
                  ),
                ),
                onChanged: (v) => setS(() => selectedNakshatra = v ?? 0),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocale.s(context, 'cancel_btn')),
            ),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _members.add(FamilyMember(
                    name: nameCtrl.text.trim(),
                    nakshatraTa: _nakshatras[selectedNakshatra],
                    nakshatraIndex: selectedNakshatra,
                  ));
                  _saveMembers();
                });
                Navigator.pop(ctx);
              },
              child: Text(AppLocale.s(context, 'save_btn')),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMember(int index) {
    setState(() {
      _members.removeAt(index);
      _saveMembers();
    });
  }

  String _chandrashtamamRasi(int nakshatraIndex) {
    final rasiIndex = nakshatraIndex ~/ 2;
    final chandrashtaRasi = (rasiIndex + 7) % 12;
    const rasis = [
      'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்',
      'சிம்மம்', 'கன்னி', 'துலாம்', 'விருச்சிகம்',
      'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
    ];
    return rasis[chandrashtaRasi];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTa = AppLocale.isTa(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_family_stars')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMember,
            tooltip: AppLocale.s(context, 'add_btn'),
          ),
        ],
      ),
      body: _members.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(AppLocale.s(context, 'star_book_empty'), style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.add),
                    label: Text(AppLocale.s(context, 'add_btn')),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _members.length,
              itemBuilder: (_, i) {
                final m = _members[i];
                final chandrashtamam = _chandrashtamamRasi(m.nakshatraIndex);
                final translatedChandra = AppLocale.translateRasiString(context, chandrashtamam);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        m.name.characters.first,
                        style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(m.name,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${AppLocale.s(context, 'filter_star')}: ${AppLocale.starName(context, m.nakshatraIndex)}',
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(
                          '${AppLocale.s(context, 'chandrashtamam')}: $translatedChandra',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteMember(i),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _members.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addMember,
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }
}
