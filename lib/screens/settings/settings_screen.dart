import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('settings');
  }

  bool _get(String key, bool def) => _box.get(key, defaultValue: def) as bool;
  String _getString(String key, String def) =>
      _box.get(key, defaultValue: def) as String;

  void _set(String key, dynamic value) {
    _box.put(key, value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = _get('dark_mode', false);
    final isElder = _get('elder_mode', false);
    final isVakiya = _getString('panchangam_type', 'vakiya') == 'vakiya';
    final userRasiIdx = _box.get('user_rasi', defaultValue: -1) as int;
    final lang = _getString('language', 'ta');
    final isTa = lang == 'ta';

    final text = {
      'title': isTa ? 'அமைப்புகள்' : 'Settings',
      'appearance': isTa ? 'தோற்றம்' : 'Appearance',
      'dark_mode': isTa ? 'இருண்ட பயன்முறை' : 'Dark Mode',
      'dark_mode_sub': isTa ? 'இருண்ட பின்னணி' : 'Dark Theme',
      'elder_mode': isTa ? 'முதியோர் பயன்முறை' : 'Elder Mode',
      'elder_mode_sub': isTa ? 'எழுத்து அளவை 25% அதிகரிக்கும்' : 'Increases text size by 25%',
      'panchangam': isTa ? 'பஞ்சாங்கம்' : 'Panchangam System',
      'vakiya': isTa ? 'வாக்கிய பஞ்சாங்கம்' : 'Vakiya Panchangam',
      'vakiya_sub': isTa ? 'தமிழ்நாடு பாரம்பரிய முறை' : 'Tamil Nadu Traditional System',
      'drik': isTa ? 'திருக் / வேத பஞ்சாங்கம்' : 'Drik / Vedic Panchangam',
      'drik_sub': isTa ? 'கணக்கீட்டு முறை' : 'Calculation System',
      'your_rasi': isTa ? 'உங்கள் ராசி' : 'Your Rasi / Zodiac',
      'rasi_select': isTa ? 'ராசி தேர்வு' : 'Zodiac Selection',
      'rasi_hint': isTa ? 'ராசி தேர்ந்தெடுக்கவும்' : 'Select Zodiac',
      'language_sec': isTa ? 'மொழி / Language' : 'Language / மொழி',
      'notifications': isTa ? 'அறிவிப்புகள்' : 'Notifications',
      'notify_nalla_neram': isTa ? 'தினசரி நல்ல நேரம் அறிவிப்பு' : 'Daily Auspicious Time Alert',
      'notify_nalla_neram_sub': isTa ? 'காலை 6:00 மணிக்கு' : 'At 6:00 AM daily',
      'notify_festivals': isTa ? 'விழா அறிவிப்பு' : 'Festival Alerts',
      'notify_festivals_sub': isTa ? 'முதல் நாள் இரவு' : 'Night before event',
      'about': isTa ? 'பயன்பாட்டு பற்றி' : 'About Application',
      'version': isTa ? 'பதிப்பு' : 'Version',
      'privacy': isTa ? 'தனியுரிமை கொள்கை' : 'Privacy Policy',
    };

    final rasiList = isTa
        ? [
            'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்',
            'சிம்மம்', 'கன்னி', 'துலாம்', 'விருச்சிகம்',
            'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
          ]
        : [
            'Aries (Mesham)', 'Taurus (Rishabam)', 'Gemini (Midhunam)', 'Cancer (Kadagam)',
            'Leo (Simmam)', 'Virgo (Kanni)', 'Libra (Thulaam)', 'Scorpio (Viruchigam)',
            'Sagittarius (Dhanusu)', 'Capricorn (Magaram)', 'Aquarius (Kumbam)', 'Pisces (Meenam)',
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(text['title']!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ── Language Section ──────────────────────────────────────────────
          _sectionHeader(theme, text['language_sec']!),
          RadioListTile<String>(
            title: const Text('தமிழ் (Tamil)'),
            value: 'ta',
            groupValue: lang,
            onChanged: (v) {
              if (v != null) _set('language', v);
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: lang,
            onChanged: (v) {
              if (v != null) _set('language', v);
            },
          ),
          const Divider(),

          // ── Appearance Section ────────────────────────────────────────────
          _sectionHeader(theme, text['appearance']!),
          SwitchListTile(
            title: Text(text['dark_mode']!),
            subtitle: Text(text['dark_mode_sub']!),
            value: isDark,
            onChanged: (v) => _set('dark_mode', v),
          ),
          SwitchListTile(
            title: Text(text['elder_mode']!),
            subtitle: Text(text['elder_mode_sub']!),
            value: isElder,
            onChanged: (v) => _set('elder_mode', v),
          ),
          const Divider(),

          // ── Panchangam Section ────────────────────────────────────────────
          _sectionHeader(theme, text['panchangam']!),
          RadioListTile<String>(
            title: Text(text['vakiya']!),
            subtitle: Text(text['vakiya_sub']!),
            value: 'vakiya',
            groupValue: isVakiya ? 'vakiya' : 'drik',
            onChanged: (v) => _set('panchangam_type', v),
          ),
          RadioListTile<String>(
            title: Text(text['drik']!),
            subtitle: Text(text['drik_sub']!),
            value: 'drik',
            groupValue: isVakiya ? 'vakiya' : 'drik',
            onChanged: (v) => _set('panchangam_type', v),
          ),
          const Divider(),

          // ── Zodiac Rasi Section ───────────────────────────────────────────
          _sectionHeader(theme, text['your_rasi']!),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: text['rasi_select'],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: userRasiIdx == -1 ? null : userRasiIdx,
              hint: Text(text['rasi_hint']!),
              items: List.generate(
                rasiList.length,
                (i) => DropdownMenuItem(value: i, child: Text(rasiList[i])),
              ),
              onChanged: (v) {
                if (v != null) _set('user_rasi', v);
              },
            ),
          ),
          const Divider(),

          // ── Notifications Section ─────────────────────────────────────────
          _sectionHeader(theme, text['notifications']!),
          SwitchListTile(
            title: Text(text['notify_nalla_neram']!),
            subtitle: Text(text['notify_nalla_neram_sub']!),
            value: _get('notify_nalla_neram', true),
            onChanged: (v) => _set('notify_nalla_neram', v),
          ),
          SwitchListTile(
            title: Text(text['notify_festivals']!),
            subtitle: Text(text['notify_festivals_sub']!),
            value: _get('notify_festivals', true),
            onChanged: (v) => _set('notify_festivals', v),
          ),
          const Divider(),

          // ── About Section ─────────────────────────────────────────────────
          _sectionHeader(theme, text['about']!),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(text['version']!),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(text['privacy']!),
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
