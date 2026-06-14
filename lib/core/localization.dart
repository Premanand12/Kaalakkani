import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppLocale {
  static const rasiNamesTa = [
    'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்',
    'சிம்மம்', 'கன்னி', 'துலாம்', 'விருச்சிகம்',
    'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
  ];

  static const rasiNamesEn = [
    'Aries (Mesham)', 'Taurus (Rishabam)', 'Gemini (Midhunam)', 'Cancer (Kadagam)',
    'Leo (Simmam)', 'Virgo (Kanni)', 'Libra (Thulaam)', 'Scorpio (Viruchigam)',
    'Sagittarius (Dhanusu)', 'Capricorn (Magaram)', 'Aquarius (Kumbam)', 'Pisces (Meenam)',
  ];

  static const monthsTa = [
    'சித்திரை', 'வைகாசி', 'ஆனி', 'ஆடி',
    'ஆவணி', 'புரட்டாசி', 'ஐப்பசி', 'கார்த்திகை',
    'மார்கழி', 'தை', 'மாசி', 'பங்குனி',
  ];

  static const monthsEn = [
    'Chithirai', 'Vaikasi', 'Aani', 'Aadi',
    'Aavani', 'Purattasi', 'Aippasi', 'Karthigai',
    'Margazhi', 'Thai', 'Maasi', 'Panguni',
  ];

  static const weekdaysTa = [
    'ஞாயிறு', 'திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி'
  ];

  static const weekdaysEn = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  static const englishMonths = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const englishMonthsFull = [
    '', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const starNamesTa = [
    'அஸ்வினி', 'பரணி', 'கார்த்திகை', 'ரோஹிணி',
    'மிருகசீரிஷம்', 'திருவாதிரை', 'புனர்பூசம்', 'பூசம்',
    'ஆயில்யம்', 'மகம்', 'பூரம்', 'உத்திரம்',
    'ஹஸ்தம்', 'சித்திரை', 'சுவாதி', 'விசாகம்',
    'அனுஷம்', 'கேட்டை', 'மூலம்', 'பூராடம்',
    'உத்திராடம்', 'திருவோணம்', 'அவிட்டம்', 'சதயம்',
    'பூரட்டாதி', 'உத்தரட்டாதி', 'ரேவதி',
  ];

  static const starNamesEn = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini',
    'Mrigashirsha', 'Ardra', 'Punarvasu', 'Pushya',
    'Ashlesha', 'Magha', 'Purva Phalguni', 'Uttara Phalguni',
    'Hasta', 'Chitra', 'Swati', 'Vishakha',
    'Anuradha', 'Jyeshtha', 'Mula', 'Purva Ashadha',
    'Uttara Ashadha', 'Shravana', 'Dhanishtha', 'Shatabhisha',
    'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati',
  ];

  static final _dict = {
    'ta': {
      // Bottom navigation tabs
      'tab_today': 'இன்று',
      'tab_month': 'மாதம்',
      'tab_rasipalan': 'ராசி',
      'tab_muhurtham': 'முகூர்த்தம்',
      'tab_more': 'மேலும்',

      // Home Screen dashboard
      'panchangam_details': 'பஞ்சாங்க விவரங்கள்',
      'timing_details': 'இன்றைய நல்ல நேரம் & ராகு காலங்கள்',
      'soolam_melnokku': 'சூலம் & மேல்நோக்கு',
      'kural_title': 'இன்றைய திருக்குறள்',
      'planets_title': 'கிரக நிலைகள்',
      'sun_moon_title': 'சூரிய / சந்திர நேரம்',
      'thithi': 'திதி',
      'nakshatra': 'நட்சத்திரம்',
      'yoga': 'யோகம்',
      'karanam': 'கரணம்',
      'weekday': 'வாரம்',
      'soolam_direction': 'சூலம் திசை',
      'remedy': 'பரிகாரம்',
      'melnokku_day': 'மேல்நோக்கு நாள்',
      'chandrashtamam_rasi': 'சந்திராஷ்டமம் ராசி',
      'sunrise': 'சூரிய உதயம்',
      'sunset': 'சூரிய அஸ்தமனம்',
      'kural_explanation': 'விளக்கம்',
      'gold_price_title': 'இன்றைய விலை நிலவரம் (சென்னை)',
      'gold_22k': '💛 தங்கம் 22K (1g)',
      'silver_1g': '🩶 வெள்ளி (1g)',
      'petrol': '⛽ பெட்ரோல்',
      'yes': 'ஆம் ✓',
      'no': 'இல்லை',
      'fasting_day': 'விரத நாள் 🕉️',
      'muhurtham_day': 'சுப முகூர்த்தம் 🌸',
      'kari_day': 'கரி நாள் ⚠️',
      'fest_day': 'விசேஷ நாள் 🎉',
      'today_astrology': 'இன்றைய ராசி பலன்',
      'good_times': 'நல்ல நேரங்கள்',
      'bad_times': 'கவனமான நேரங்கள்',
      'nalla_neram': 'நல்ல நேரம்',
      'gowri_nalla_neram': 'கௌரி நல்ல நேரம்',
      'abhijit': 'அபிஜித்',
      'rahukaalam': 'ராகுகாலம்',
      'yamakandam': 'யமகண்டம்',
      'kuligai': 'குளிகை',
      'chandrashtamam_alert': 'சந்திராஷ்டமம் எச்சரிக்கை! உங்கள் ராசிக்கு இன்று சந்திராஷ்டமம். புதிய காரியங்களைத் தவிர்க்கவும்.',
      'chandrashtamam': 'சந்திராஷ்டமம்',
      'timings_title': 'இன்றைய நல்ல நேரம் & ராகு காலங்கள்',

      // Month view
      'legend_festival': 'பண்டிகை',
      'legend_fasting': 'விரதம்',
      'legend_muhurtham': 'முகூர்த்தம்',
      'month_festivals': 'இந்த மாத திருவிழாக்கள்',
      'no_festivals': 'இந்த மாதம் பண்டிகை இல்லை',

      // Rasipalan view
      'horoscope_title': 'இன்றைய ராசி பலன்',
      'tab_day': 'நாள்',
      'tab_week': 'வாரம்',
      'tab_month_tab': 'மாதம்',
      'no_data': 'தரவு இல்லை',
      'weekly_prediction_all': 'வாரம் நல்லதாக அமையும். உழைப்பிற்கு ஏற்ற பலன் கிடைக்கும்.',
      'lucky_color': 'நிறம்',
      'lucky_num': 'எண்',

      // More screen view
      'more_app_bar': 'மேலும் வசதிகள்',
      'tools_sec': 'கருவிகள்',
      'gold_silver_label': 'தங்கம் /\nவெள்ளி',
      'diesel_label': 'டீசல்',
      'lpg_label': 'LPG சிலிண்டர்',
      'petrol_label': 'பெட்ரோல் (சென்னை)',
      'rate_not_found': 'விலை தரவு கிடைக்கவில்லை',

      // Tools
      'tool_porutham': 'திருமண\nபொருத்தம்',
      'tool_baby_names': 'குழந்தை\nபெயர்கள்',
      'tool_palli': 'பல்லி விழும்\nபலன்',
      'tool_numerology': 'எண்\nகணிதம்',
      'tool_moi': 'மொய்\nகணக்கு',
      'tool_gold': 'தங்கம் /\nவெள்ளி',
      'tool_thirukkural': 'திருக்\nகுறள்',
      'tool_family_stars': 'குடும்ப\nநட்சத்திரம்',
      'tool_share_card': 'பஞ்சாங்க\nபகிர்வு',
      'tool_kanavu': 'கனவு\nபலன்கள்',
      'tool_date_converter': 'தமிழ் தேதி\nமாற்றி',
      'tool_settings': 'அமைப்\nபுகள்',

      // ── Sub-tools Localisation Keys ─────────────────────────
      'groom_star': 'மணமகன் நட்சத்திரம்',
      'bride_star': 'மணமகள் நட்சத்திரம்',
      'calculate_btn': 'பொருத்தம் கணக்கிடு',
      'select_hint': 'தேர்வு செய்யவும்',
      'porutham_note': 'குறிப்பு: இந்த கணக்கீடு பாரம்பரிய ஜோதிட முறைப்படி. இறுதி முடிவுக்கு அனுபவம் வாய்ந்த ஜோதிடரை ஆலோசிக்கவும்.',
      'score_suffix': 'பொருத்தம்',
      'matches_yes': 'பொருந்தும்',
      'matches_no': 'பொருந்தாது',
      'score_good': 'மிகவும் நல்ல பொருத்தம் ✓',
      'score_average': 'சாதாரண பொருத்தம்',
      'score_careful': 'கவனம் தேவை — பெரியோரை ஆலோசிக்கவும்',
      
      'filter_star': 'நட்சத்திரம்',
      'all_filter': 'அனைத்தும்',
      'gender_all': 'அனைத்தும்',
      'gender_male': 'ஆண்',
      'gender_female': 'பெண்',
      'no_names_found': 'பெயர்கள் இல்லை',
      'starting_letter_label': 'தொடக்க எழுத்து',

      'your_name_label': 'உங்கள் பெயர் (ஆங்கிலத்தில்)',
      'dob_label': 'பிறந்த தேதி',
      'select_date_btn': 'தேதி தேர்வு செய்யவும்',
      'calculate_numerology': 'கணக்கிடு',
      'name_num_label': 'பெயர் எண்',
      'life_path_num_label': 'வாழ்க்கை பாதை எண்',

      'new_moi_title': 'புதிய மொய் பதிவு',
      'moi_name': 'பெயர்',
      'moi_amount': 'தொகை (₹)',
      'moi_occasion': 'நிகழ்ச்சி (விரும்பினால்)',
      'add_submit': 'சேர்க்கவும்',
      'total_moi_label': 'மொத்த மொய்',
      'no_moi_records': 'மொய் பதிவுகள் இல்லை.\n+ சேர்க்கவும் பட்டனை தட்டவும்.',
      'delete_confirm_title': 'நீக்கவும்?',
      'delete_no': 'இல்லை',
      'delete_yes': 'ஆம்',

      'gold_22k_label': 'தங்கம் 22K',
      'gold_24k_label': 'தங்கம் 24K',
      'silver_label': 'வெள்ளி',
      'one_gram': '1 கிராம்',
      'one_sovereign': '1 சவரன் (8g)',
      'last_updated_label': 'கடைசி புதுப்பிப்பு',
      'rate_today': 'இன்று',

      'tab_kural_today': 'இன்றைய குறள்',
      'tab_kural_all': 'அனைத்தும்',
      'kural_db_err': 'குறள் தகவல்கள் ஏற்றப்படவில்லை.\nDB-யில் திருக்குறள் சேர்க்கவும்.',
      'kural_search_hint': 'குறள் தேடுங்கள்...',
      'adhigaram_prefix': 'அதிகாரம்',
      'kural_num_prefix': 'குறள்',
      'no_kurals_found': 'குறள்கள் இல்லை',

      'add_family_title': 'குடும்பத்தினர் சேர்க்கவும்',
      'cancel_btn': 'ரத்து',
      'save_btn': 'சேர்',
      'star_book_empty': 'குடும்பத்தினரின் நட்சத்திரங்களை சேர்க்கவும்',

      'share_card_subtitle': 'இந்த அட்டையை WhatsApp, Instagram போன்றவற்றில் பகிரலாம்',
      'share_btn': 'பகிர்',

      'search_dream_hint': 'கனவை தேடுங்கள்... (பாம்பு, தங்கம், ...)',
      'dream_count_suffix': 'கனவுகள்',

      'gregorian_date_label': 'ஆங்கில தேதி',
      'convert_btn': 'மாற்று',
      'tamil_date_label': 'தமிழ் தேதி',
      'tamil_month_row': 'தமிழ் மாதம்',
      'tamil_year_row': 'தமிழ் ஆண்டு',
      'weekday_row': 'வாரம்',
      'panchangam_details_label': 'பஞ்சாங்க விவரம்',
      'date_conv_no_data': 'இந்த தேதிக்கு தகவல் இல்லை (2020–2030 மட்டுமே)',
      'select_event_type': 'நிகழ்வு வகை தேர்வு',
      'select_date_range': 'தேதி வரம்பு தேர்வு',
      'search_muhurtham_btn': 'முகூர்த்த தேதிகள் தேடு',
      'no_muhurtham_found': 'இந்த தேதி வரம்பில் முகூர்த்தம் கிடைக்கவில்லை.\nவரம்பை நீட்டுங்கள்.',
      'muhurtham_search_title': 'சுப முகூர்த்தம் தேடல்',
    },
    'en': {
      // Bottom navigation tabs
      'tab_today': 'Today',
      'tab_month': 'Month',
      'tab_rasipalan': 'Horoscope',
      'tab_muhurtham': 'Muhurtham',
      'tab_more': 'More',

      // Home Screen dashboard
      'panchangam_details': 'Panchangam Details',
      'timing_details': 'Auspicious & Inauspicious Times',
      'soolam_melnokku': 'Soolam & Melnokku',
      'kural_title': 'Thirukkural of the Day',
      'planets_title': 'Planetary Positions',
      'sun_moon_title': 'Sun / Moon Timings',
      'thithi': 'Thithi',
      'nakshatra': 'Nakshatra',
      'yoga': 'Yoga',
      'karanam': 'Karanam',
      'weekday': 'Weekday',
      'soolam_direction': 'Soolam Direction',
      'remedy': 'Remedy',
      'melnokku_day': 'Melnokku Day',
      'chandrashtamam_rasi': 'Chandrashtamam Rasi',
      'sunrise': 'Sunrise',
      'sunset': 'Sunset',
      'kural_explanation': 'Explanation',
      'gold_price_title': 'Today\'s Prices (Chennai)',
      'gold_22k': '💛 Gold 22K (1g)',
      'silver_1g': '🩶 Silver (1g)',
      'petrol': '⛽ Petrol',
      'yes': 'Yes ✓',
      'no': 'No',
      'fasting_day': 'Fasting Day 🕉️',
      'muhurtham_day': 'Muhurtham 🌸',
      'kari_day': 'Kari Day ⚠️',
      'fest_day': 'Festival 🎉',
      'today_astrology': 'Daily Horoscope',
      'good_times': 'Auspicious Timings',
      'bad_times': 'Inauspicious Timings',
      'nalla_neram': 'Nalla Neram',
      'gowri_nalla_neram': 'Gowri Nalla Neram',
      'abhijit': 'Abhijit',
      'rahukaalam': 'Rahukaalam',
      'yamakandam': 'Yamakandam',
      'kuligai': 'Kuligai',
      'chandrashtamam_alert': 'Chandrashtamam Warning! Today is Chandrashtamam for your Rasi. Avoid starting new ventures.',
      'chandrashtamam': 'Chandrashtamam',
      'timings_title': 'Auspicious & Inauspicious Times',

      // Month view
      'legend_festival': 'Festival',
      'legend_fasting': 'Fasting',
      'legend_muhurtham': 'Muhurtham',
      'month_festivals': 'Festivals of this Month',
      'no_festivals': 'No festivals this month',

      // Rasipalan view
      'horoscope_title': 'Daily Horoscope',
      'tab_day': 'Daily',
      'tab_week': 'Weekly',
      'tab_month_tab': 'Monthly',
      'no_data': 'No data available',
      'weekly_prediction_all': 'This week will be favorable. You will get rewards for your hard work.',
      'lucky_color': 'Color',
      'lucky_num': 'Number',

      // More screen view
      'more_app_bar': 'More Features',
      'tools_sec': 'Utilities & Tools',
      'gold_silver_label': 'Gold & Silver\nRates',
      'diesel_label': 'Diesel',
      'lpg_label': 'LPG Cylinder',
      'petrol_label': 'Petrol (Chennai)',
      'rate_not_found': 'Price data not available',

      // Tools
      'tool_porutham': 'Marriage\nMatching',
      'tool_baby_names': 'Baby\nNames',
      'tool_palli': 'Lizard\nPredictions',
      'tool_numerology': 'Numerology',
      'tool_moi': 'Moi\nRegister',
      'tool_gold': 'Gold & Silver\nRates',
      'tool_thirukkural': 'Daily\nThirukkural',
      'tool_family_stars': 'Family Star\nBook',
      'tool_share_card': 'Share Daily\nCard',
      'tool_kanavu': 'Dream\nMeanings',
      'tool_date_converter': 'Tamil Date\nConverter',
      'tool_settings': 'Settings',

      // ── Sub-tools Localisation Keys ─────────────────────────
      'groom_star': 'Groom\'s Star / Nakshatra',
      'bride_star': 'Bride\'s Star / Nakshatra',
      'calculate_btn': 'Calculate Compatibility',
      'select_hint': 'Select Star',
      'porutham_note': 'Note: This calculation is based on traditional Vedic astrology. For final decisions, consult a trusted astrologer.',
      'score_suffix': 'Matches',
      'matches_yes': 'Compatible',
      'matches_no': 'Not Compatible',
      'score_good': 'Excellent Compatibility ✓',
      'score_average': 'Average Compatibility',
      'score_careful': 'Caution — Consult an astrologer',
      
      'filter_star': 'Nakshatra',
      'all_filter': 'All Stars',
      'gender_all': 'All Genders',
      'gender_male': 'Boy',
      'gender_female': 'Girl',
      'no_names_found': 'No Names found',
      'starting_letter_label': 'Starting Letter',

      'your_name_label': 'Your Name (in English)',
      'dob_label': 'Date of Birth',
      'select_date_btn': 'Select Date',
      'calculate_numerology': 'Calculate',
      'name_num_label': 'Name Number',
      'life_path_num_label': 'Life Path Number',

      'new_moi_title': 'New Moi Entry',
      'moi_name': 'Name',
      'moi_amount': 'Amount (₹)',
      'moi_occasion': 'Occasion (Optional)',
      'add_submit': 'Save Record',
      'total_moi_label': 'Total Moi Collected',
      'no_moi_records': 'No records yet.\nTap "+ Add New" button above.',
      'delete_confirm_title': 'Delete Entry?',
      'delete_no': 'Cancel',
      'delete_yes': 'Delete',

      'gold_22k_label': 'Gold 22K',
      'gold_24k_label': 'Gold 24K',
      'silver_label': 'Silver',
      'one_gram': '1 Gram',
      'one_sovereign': '1 Sovereign (8g)',
      'last_updated_label': 'Last Updated',
      'rate_today': 'today',

      'tab_kural_today': 'Today\'s Kural',
      'tab_kural_all': 'Search All',
      'kural_db_err': 'Thirukkural could not be loaded.\nPlease check the DB.',
      'kural_search_hint': 'Search Kural text...',
      'adhigaram_prefix': 'Adhigaram / Chapter',
      'kural_num_prefix': 'Kural',
      'no_kurals_found': 'No Kurals match',

      'add_family_title': 'Add Family Member',
      'cancel_btn': 'Cancel',
      'save_btn': 'Add',
      'star_book_empty': 'Please add family members\' birth stars',

      'share_card_subtitle': 'You can share this card via WhatsApp, Instagram, etc.',
      'share_btn': 'Share',

      'search_dream_hint': 'Search dreams... (e.g., snake, gold)',
      'dream_count_suffix': 'dreams',

      'gregorian_date_label': 'Gregorian Date',
      'convert_btn': 'Change Date',
      'tamil_date_label': 'Tamil Date',
      'tamil_month_row': 'Tamil Month',
      'tamil_year_row': 'Tamil Year',
      'weekday_row': 'Weekday',
      'panchangam_details_label': 'Panchangam Details',
      'date_conv_no_data': 'No information for this date (2020-2030 only)',
      'select_event_type': 'Select Event Type',
      'select_date_range': 'Select Date Range',
      'search_muhurtham_btn': 'Search Muhurtham Dates',
      'no_muhurtham_found': 'No Muhurtham dates found in this range.\nPlease extend the range.',
      'muhurtham_search_title': 'Auspicious Muhurtham Search',

      // Individual matching categories
      'தின பொருத்தம்': 'Dina Porutham (Health)',
      'கண பொருத்தம்': 'Gana Porutham (Temperament)',
      'மஹேந்திர பொருத்தம்': 'Mahendra Porutham (Progeny)',
      'ஸ்திரீ தீர்க்க பொருத்தம்': 'Stree Deera Porutham (Longevity)',
      'யோனி பொருத்தம்': 'Yoni Porutham (Physical Affinity)',
      'ராசி பொருத்தம்': 'Rasi Porutham (Zodiac Harmony)',
      'ராஜ்ஜு பொருத்தம்': 'Rajju Porutham (Husband\'s Longevity)',
      'வேதை பொருத்தம்': 'Vedha Porutham (Afflictions Check)',
      'வஸ்ய பொருத்தம்': 'Vasya Porutham (Mutual Attraction)',
      'நாடி பொருத்தம்': 'Nadi Porutham (Physiological Health)',
    }
  };

  static String s(BuildContext context, String key) {
    final box = Hive.box('settings');
    final lang = box.get('language', defaultValue: 'ta') as String;
    return _dict[lang]?[key] ?? key;
  }

  static bool isTa(BuildContext context) {
    final box = Hive.box('settings');
    final lang = box.get('language', defaultValue: 'ta') as String;
    return lang == 'ta';
  }

  static String starName(BuildContext context, int index) {
    if (index < 0 || index >= 27) return '';
    return isTa(context) ? starNamesTa[index] : starNamesEn[index];
  }

  static String rasiName(BuildContext context, int index) {
    if (index < 0 || index >= 12) return '';
    return isTa(context) ? rasiNamesTa[index] : rasiNamesEn[index];
  }

  static String tamilMonthName(BuildContext context, String monthTaName) {
    final idx = monthsTa.indexOf(monthTaName);
    if (idx < 0) return monthTaName;
    return isTa(context) ? monthsTa[idx] : monthsEn[idx];
  }

  static String translateRasiString(BuildContext context, String rasiTaName) {
    final idx = rasiNamesTa.indexOf(rasiTaName);
    if (idx < 0) return rasiTaName;
    return isTa(context) ? rasiNamesTa[idx] : rasiNamesEn[idx];
  }

  static const horoscopePredictionsTaToEn = {
    'பொருளாதார நிலை மேம்படும். தொழிலில் வெற்றி கிடைக்கும். குடும்பத்தில் சுகம் உண்டாகும்.':
        'Financial status will improve. Business success is assured. Happiness will prevail in the family.',
    'செலவுகள் அதிகரிக்கலாம். சேமிப்பில் கவனம் தேவை. உறவினர்களால் உதவி கிடைக்கும்.':
        'Expenses might increase. Pay attention to savings. Support will be available from relatives.',
    'நல்ல நேரம். முக்கிய முடிவு எடுக்கலாம். வேலையில் பதவி உயர்வு சாத்தியம்.':
        'Favorable time. Important decisions can be taken. Career promotion is possible.',
    'நல்ல நேரம். முக்கிய முடிவுகள் எடுக்கலாம். வேலையில் பதவி உயர்வு சாத்தியம்.':
        'Favorable time. Important decisions can be taken. Career promotion is possible.',
    'உடல் நலத்தில் கவனம் தேவை. பயணம் தவிர்க்கவும். குடும்பத்தில் அமைதி நிலவும்.':
        'Pay attention to health. Avoid travel. Family environment will be peaceful.',
    'அரசு காரியங்கள் தாமதமாகலாம். பொறுமை தேவை. நண்பர்களால் உதவி கிடைக்கும்.':
        'Government matters may get delayed. Patience is required. Friends will offer help.',
    'வியாபாரத்தில் லாபம் உண்டாகும். பணம் வரும். நல்ல திட்டங்கள் வெற்றியடையும்.':
        'Profits in business. Inflow of money. Good plans will succeed.',
    'கூட்டாளிகளுடன் கருத்து வேறுபாடு வரலாம். சட்ட விஷயங்களில் கவனம். சுகம் நல்லது.':
        'Differences of opinion with partners may arise. Pay attention to legal matters. General health remains good.',
    'ரகசிய விஷயங்கள் வெளிப்படலாம். கவனமாக இருக்கவும்.':
        'Secrets might be revealed. Exercise caution.',
    'குரு பலம் நல்லது. யாத்திரை வாய்ப்பு உண்டு. வெளிநாட்டு தொடர்பு ஏற்படும்.':
        'Jupiter influence is good. Travel opportunities exist. Foreign connections will be established.',
    'உழைப்பிற்கு ஏற்ற பலன் கிடைக்கும். தொழிலில் முன்னேற்றம்.':
        'Efforts will bring matching rewards. Progress in career/business.',
    'நட்பு வட்டம் விரிவடையும். கலை ஆர்வம் அதிகரிக்கும்.':
        'Friend circle will expand. Interest in arts will increase.',
    'ஆன்மிக ஆர்வம் அதிகரிக்கும். மன அமைதி உண்டாகும்.':
        'Spiritual interest will rise. Peace of mind is assured.',
  };

  static String translatePrediction(BuildContext context, String predictionTa) {
    if (isTa(context)) return predictionTa;
    return horoscopePredictionsTaToEn[predictionTa] ?? predictionTa;
  }

  static const colorsTaToEn = {
    'சிவப்பு': 'Red',
    'வெள்ளை': 'White',
    'பச்சை': 'Green',
    'தங்க மஞ்சள்': 'Golden Yellow',
    'நீலம்': 'Blue',
    'மஞ்சள்': 'Yellow',
    'கருப்பு': 'Black',
  };

  static String translateColor(BuildContext context, String colorTa) {
    if (isTa(context)) return colorTa;
    return colorsTaToEn[colorTa] ?? colorTa;
  }

  static const palliBodyPartsTaToEn = {
    'தலை': 'Head',
    'வலது கண்': 'Right Eye',
    'இடது கண்': 'Left Eye',
    'வலது தோள்': 'Right Shoulder',
    'இடது தோள்': 'Left Shoulder',
    'வலது கை': 'Right Hand',
    'வலது கால்': 'Right Foot',
    'இடது கால்': 'Left Foot',
    'முதுகு': 'Back',
    'வயிறு': 'Stomach',
    'வலது கன்னம்': 'Right Cheek',
    'நெற்றி': 'Forehead',
    'மூக்கு': 'Nose',
  };

  static const palliTimesTaToEn = {
    'காலை': 'Morning',
    'மதியம்': 'Afternoon',
    'மாலை': 'Evening',
  };

  static const palliMeaningsTaToEn = {
    'அரசாட்சி கிடைக்கும்': 'Will gain power/authority',
    'மங்களம் உண்டாகும்': 'Auspicious events will happen',
    'நன்மை உண்டாகும்': 'Good things will happen',
    'கஷ்டம் வரும்': 'Difficulties may arise',
    'பணம் வரும்': 'Wealth/Money inflow',
    'கவலை வரும்': 'Worries may arise',
    'விருந்து கிடைக்கும்': 'Feast/Guest invitation',
    'பயணம் நடக்கும்': 'Will travel',
    'செலவு வரும்': 'Expenses will occur',
    'எதிர்பாராத பணம் வரும்': 'Unexpected wealth',
    'நல்ல செய்தி கிடைக்கும்': 'Good news will arrive',
    'திருமணம் நடக்கும்': 'Marriage will take place',
    'உயர்வு கிடைக்கும்': 'Promotion/Elevation',
    'சுபகாரியம் நடக்கும்': 'Auspicious tasks will happen',
  };

  static String translatePalliBodyPart(BuildContext context, String part) {
    if (isTa(context)) return part;
    return palliBodyPartsTaToEn[part] ?? part;
  }

  static String translatePalliTime(BuildContext context, String time) {
    if (isTa(context)) return time;
    return palliTimesTaToEn[time] ?? time;
  }

  static String translatePalliMeaning(BuildContext context, String meaning) {
    if (isTa(context)) return meaning;
    return palliMeaningsTaToEn[meaning] ?? meaning;
  }

  static String translatePalliGender(BuildContext context, String gender) {
    if (isTa(context)) return gender;
    if (gender == 'ஆண்') return 'Male';
    if (gender == 'பெண்') return 'Female';
    return gender;
  }

  static const yogasTaToEn = {
    "விஷ்கம்பம்": "Vishkambha",
    "பிரீதி": "Preeti",
    "ஆயுஷ்மான்": "Ayushman",
    "சௌபாக்கியம்": "Saubhagya",
    "சோபனம்": "Shobhana",
    "அதிகண்டம்": "Atiganda",
    "சுகர்மா": "Sukarma",
    "த்ருதி": "Dhriti",
    "சூலம்": "Shoola",
    "கண்டம்": "Ganda",
    "வ்ருத்தி": "Vriddhi",
    "த்ருவம்": "Dhruva",
    "வ்யாகாதம்": "Vyaghata",
    "ஹர்ஷணம்": "Harshana",
    "வஜ்ரம்": "Vajra",
    "சித்தி": "Siddhi",
    "வ்யதீபாதம்": "Vyatipata",
    "வரீயான்": "Variyan",
    "பரிகம்": "Parigha",
    "சிவம்": "Shiva",
    "சித்தம்": "Siddha",
    "சாத்யம்": "Sadhya",
    "சுபம்": "Shubha",
    "சுக்லம்": "Shukla",
    "ப்ரம்மம்": "Brahma",
    "இந்திரம்": "Indra",
    "வைத்ருதி": "Vaidhriti"
  };

  static const karanamsTaToEn = {
    "கவம்": "Bava",
    "கௌலவம்": "Kaulava",
    "கரஜம்": "Taitila",
    "திஷ்டிலம்": "Garaja",
    "கரணம்": "Karanam",
    "வணிஜம்": "Vanija",
    "விஷ்டி": "Vishti",
    "சகுனி": "Shakuni",
    "சதுஷ்பாதம்": "Chatushpada",
    "நாகவம்": "Naga",
    "கிம்ஸ்துக்னம்": "Kimstughna"
  };

  static String translateYoga(BuildContext context, String yogaTa) {
    if (isTa(context)) return yogaTa;
    return yogasTaToEn[yogaTa] ?? yogaTa;
  }

  static String translateKaranam(BuildContext context, String karanamTa) {
    if (isTa(context)) return karanamTa;
    return karanamsTaToEn[karanamTa] ?? karanamTa;
  }

  static const _muhurthamEventsTaToEn = {
    'திருமணம்': 'Marriage / Wedding',
    'கிரஹப்பிரவேசம்': 'Housewarming (Grihapravesham)',
    'வாகன வாங்குதல்': 'Buying Vehicle',
    'கடை திறப்பு': 'Shop Opening',
    'தொண்டில் சேர்தல்': 'Joining Service / Job',
    'குழந்தை நாமகரணம்': 'Baby Naming',
    'காது குத்துதல்': 'Ear Piercing',
    'திரோட்டில்': 'Travel / Voyage',
    'அன்னப்பிரசனம்': 'First Rice Feeding (Annaprasanam)',
  };

  static String translateMuhurthamEvent(BuildContext context, String eventTa) {
    if (isTa(context)) return eventTa;
    return _muhurthamEventsTaToEn[eventTa] ?? eventTa;
  }

  static String transliterate(String tamil) {
    if (tamil.isEmpty) return '';
    final Map<String, String> map = {
      'அ': 'A', 'ஆ': 'Aa', 'இ': 'I', 'ஈ': 'Ee', 'உ': 'U', 'ஊ': 'Oo',
      'எ': 'E', 'ஏ': 'Ae', 'ஐ': 'Ai', 'ஒ': 'O', 'ஓ': 'Oe', 'ஔ': 'Au',
      'க': 'Ka', 'கா': 'Kaa', 'கி': 'Ki', 'கீ': 'Kee', 'கு': 'Ku', 'கூ': 'Koo',
      'கெ': 'Ke', 'கே': 'Kae', 'கை': 'Kai', 'கொ': 'Ko', 'கோ': 'Koe', 'கௌ': 'Kau',
      'ச': 'Sa', 'சா': 'Saa', 'சி': 'Si', 'சீ': 'See', 'சு': 'Su', 'சூ': 'Soo',
      'செ': 'Se', 'சே': 'Sae', 'சை': 'Sai', 'சொ': 'So', 'சோ': 'Soe', 'சௌ': 'Sau',
      'த': 'Tha', 'தா': 'Thaa', 'தி': 'Thi', 'தீ': 'Thee', 'து': 'Thu', 'தூ': 'Thoo',
      'தெ': 'The', 'தே': 'Thae', 'தை': 'Thai', 'தொ': 'Tho', 'தோ': 'Thoe', 'தௌ': 'Thau',
      'ந': 'Na', 'நா': 'Naa', 'நி': 'Ni', 'நீ': 'Nee', 'நு': 'Nu', 'நூ': 'Noo',
      'நெ': 'Ne', 'நே': 'Nae', 'நை': 'Nai', 'நொ': 'No', 'நோ': 'Noe', 'நௌ': 'Nau',
      'ப': 'Pa', 'பா': 'Paa', 'பி': 'Pi', 'பீ': 'Pee', 'பு': 'Pu', 'பூ': 'Poo',
      'பெ': 'Pe', 'பே': 'Pae', 'பை': 'Pai', 'பொ': 'Po', 'போ': 'Poe', 'பௌ': 'Pau',
      'ம': 'Ma', 'மா': 'Maa', 'மி': 'Mi', 'மீ': 'Mee', 'மு': 'Mu', 'மூ': 'Moo',
      'மெ': 'Me', 'மே': 'Mae', 'மை': 'Mai', 'மொ': 'Mo', 'மோ': 'Moe', 'மௌ': 'Mau',
      'ய': 'Ya', 'யா': 'Yaa', 'யி': 'Yi', 'யீ': 'Yee', 'யு': 'Yu', 'யூ': 'Yoo',
      'யெ': 'Ye', 'யே': 'Yae', 'யை': 'Yai', 'யொ': 'Yo', 'யோ': 'Yoe', 'யௌ': 'Yau',
      'ர': 'Ra', 'ரா': 'Raa', 'ரி': 'Ri', 'ரீ': 'Ree', 'ரு': 'Ru', 'ரூ': 'Roo',
      'ரெ': 'Re', 'ரே': 'Rae', 'ரை': 'Rai', 'ரொ': 'Ro', 'ரோ': 'Roe', 'ரௌ': 'Rau',
      'ல': 'La', 'லா': 'Laa', 'லி': 'Li', 'லீ': 'Lee', 'லு': 'Lu', 'லூ': 'Loo',
      'லெ': 'Le', 'லே': 'Lae', 'லை': 'Lai', 'லொ': 'Lo', 'லோ': 'Loe', 'லௌ': 'Lau',
      'வ': 'Va', 'வா': 'Vaa', 'வி': 'Vi', 'வீ': 'Vee', 'வு': 'Vu', 'வூ': 'Voo',
      'வெ': 'Ve', 'வே': 'Vae', 'வை': 'Vai', 'வொ': 'Vo', 'வோ': 'Voe', 'வௌ': 'Vau',
      'ழ': 'Zha', 'ழா': 'Zhaa', 'ழி': 'Zhi', 'ழீ': 'Zhee', 'ழு': 'Zhu', 'ழூ': 'Zhoo',
      'ழெ': 'Zhe', 'ழே': 'Zhae', 'ழை': 'Zhai', 'ழொ': 'Zho', 'ழோ': 'Zhoe', 'ழௌ': 'Zhau',
      'ள': 'La', 'ளா': 'Laa', 'ளி': 'Li', 'ளீ': 'Lee', 'ளு': 'Lu', 'ளூ': 'Loo',
      'ளெ': 'Le', 'ளே': 'Lae', 'ளை': 'Lai', 'ளொ': 'Lo', 'ளோ': 'Loe', 'ளௌ': 'Lau',
      'ற': 'Ra', 'றா': 'Raa', 'றி': 'Ri', 'றீ': 'Ree', 'று': 'Ru', 'றூ': 'Roo',
      'றெ': 'Re', 'றே': 'Rae', 'றை': 'Rai', 'றொ': 'Ro', 'றோ': 'Roe', 'றௌ': 'Rau',
      'ன': 'Na', 'னா': 'Naa', 'னி': 'Ni', 'னீ': 'Nee', 'னு': 'Nu', 'னூ': 'Noo',
      'னெ': 'Ne', 'னே': 'Nae', 'னை': 'Nai', 'னொ': 'No', 'னோ': 'Noe', 'னௌ': 'Nau',
      'ஹ': 'Ha', 'ஹா': 'Haa', 'ஹி': 'Hi', 'ஹீ': 'Hee', 'ஹு': 'Hu', 'ஹூ': 'Hoo',
      'ஜ': 'Ja', 'ஜா': 'Jaa', 'ஜி': 'Ji', 'ஜீ': 'Jee', 'ஜு': 'Ju', 'ஜூ': 'Joo',
      'ஷ': 'Sha', 'ஷா': 'Shaa', 'ஷி': 'Shi', 'ஷீ': 'Shee', 'ஷு': 'Shu', 'ஷூ': 'Shoo',
      'ஸ': 'Sa', 'ஸா': 'Saa', 'ஸி': 'Si', 'ஸீ': 'See', 'ஸு': 'Su', 'ஸூ': 'Soo',
      'க்': 'k', 'ங்': 'ng', 'ச்': 'ch', 'ஞ்': 'nj', 'ட்': 't', 'ண்': 'n',
      'த்': 'th', 'ந்': 'n', 'ப்': 'p', 'ம்': 'm', 'ய்': 'y', 'ர்': 'r',
      'ல்': 'l', 'வ்': 'v', 'ழ்': 'zh', 'ள்': 'l', 'ற்': 'r', 'ன்': 'n',
      'ஹ்': 'h', 'ஜ்': 'j', 'ஷ்': 'sh', 'ஸ்': 's',
    };
    String res = "";
    int i = 0;
    while (i < tamil.length) {
      if (i + 1 < tamil.length) {
        final doubleChar = tamil.substring(i, i + 2);
        if (map.containsKey(doubleChar)) {
          res += map[doubleChar]!;
          i += 2;
          continue;
        }
      }
      final singleChar = tamil.substring(i, i + 1);
      res += map[singleChar] ?? singleChar;
      i += 1;
    }
    // Capitalize first letter
    if (res.isNotEmpty) {
      res = res[0].toUpperCase() + res.substring(1);
    }
    return res;
  }
}
