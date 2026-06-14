import 'package:flutter/material.dart';
import '../../data/database_helper.dart';
import '../../core/localization.dart';
import 'package:intl/intl.dart';

class TamilDateConverterScreen extends StatefulWidget {
  const TamilDateConverterScreen({super.key});

  @override
  State<TamilDateConverterScreen> createState() =>
      _TamilDateConverterScreenState();
}

class _TamilDateConverterScreenState extends State<TamilDateConverterScreen> {
  DateTime _selectedDate = DateTime.now();
  PanchangamDay? _result;
  bool _loading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null) {
      setState(() => _loading = true);
      final day = await DatabaseHelper.instance.getDay(picked);
      setState(() {
        _selectedDate = picked;
        _result = day;
        _loading = false;
      });
    }
  }

  Future<void> _loadToday() async {
    setState(() => _loading = true);
    final day = await DatabaseHelper.instance.getDay(DateTime.now());
    setState(() {
      _selectedDate = DateTime.now();
      _result = day;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTa = AppLocale.isTa(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.s(context, 'tool_date_converter').replaceAll('\n', ' ')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocale.s(context, 'gregorian_date_label'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('dd MMMM yyyy', 'en').format(_selectedDate),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            AppLocale.s(context, 'convert_btn'),
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ))
            else if (_result == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocale.s(context, 'date_conv_no_data'),
                    style: TextStyle(color: theme.colorScheme.error, fontSize: 15.0),
                  ),
                ),
              )
            else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.s(context, 'tamil_date_label'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _row(
                        AppLocale.s(context, 'tamil_year_row'),
                        isTa ? _result!.tamilYear : AppLocale.transliterate(_result!.tamilYear),
                      ),
                      _row(
                        AppLocale.s(context, 'tamil_month_row'),
                        AppLocale.tamilMonthName(context, _result!.tamilMonth),
                      ),
                      _row(
                        AppLocale.s(context, 'weekday_row'),
                        isTa ? _result!.weekdayTa : AppLocale.weekdaysEn[_result!.weekday],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.s(context, 'panchangam_details_label'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _row(
                        AppLocale.s(context, 'thithi'),
                        isTa
                            ? '${_result!.thithiTa} (${_result!.thithiPaksha})'
                            : '${_result!.thithiEn} (${_result!.thithiPaksha == 'சுக்ல' ? 'Shukla' : 'Krishna'})',
                      ),
                      _row(
                        AppLocale.s(context, 'nakshatra'),
                        isTa ? _result!.nakshatraTa : _result!.nakshatraEn,
                      ),
                      _row(
                        AppLocale.s(context, 'yoga'),
                        AppLocale.translateYoga(context, _result!.yogaTa),
                      ),
                      _row(
                        AppLocale.s(context, 'karanam'),
                        AppLocale.translateKaranam(context, _result!.karanamTa),
                      ),
                      _row(
                        AppLocale.s(context, 'sunrise'),
                        _result!.sunrise,
                      ),
                      _row(
                        AppLocale.s(context, 'sunset'),
                        _result!.sunset,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 15.5),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
