import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/localization.dart';

class MoiRegisterScreen extends StatefulWidget {
  const MoiRegisterScreen({super.key});
  @override
  State<MoiRegisterScreen> createState() => _MoiRegisterScreenState();
}

class _MoiRegisterScreenState extends State<MoiRegisterScreen> {
  final _box = Hive.box('moi_records');
  final _nameCtrl = TextEditingController();
  final _amtCtrl = TextEditingController();
  final _occasionCtrl = TextEditingController();

  List<Map> get _records => _box.values.cast<Map>().toList();
  double get _total => _records.fold(0, (s, r) => s + (r['amount'] as double? ?? 0));

  void _add() {
    if (_nameCtrl.text.isEmpty || _amtCtrl.text.isEmpty) return;
    final record = {
      'name': _nameCtrl.text,
      'amount': double.tryParse(_amtCtrl.text) ?? 0,
      'occasion': _occasionCtrl.text,
      'date': DateTime.now().toIso8601String(),
    };
    _box.add(record);
    _nameCtrl.clear(); _amtCtrl.clear(); _occasionCtrl.clear();
    setState(() {});
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20,
            MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocale.s(context, 'new_moi_title'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            TextField(controller: _nameCtrl,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(labelText: AppLocale.s(context, 'moi_name'), border: const OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _amtCtrl, keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(labelText: AppLocale.s(context, 'moi_amount'), border: const OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _occasionCtrl,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(labelText: AppLocale.s(context, 'moi_occasion'), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _add,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC4520F),
                    foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(AppLocale.s(context, 'add_submit'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC4520F), foregroundColor: Colors.white,
        title: Text(AppLocale.s(context, 'tool_moi'), 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _showAddDialog,
            child: Text(AppLocale.s(context, 'add_btn'), style: const TextStyle(color: Colors.white,
                fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Total
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFC4520F), Color(0xFF9E3F08)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(AppLocale.s(context, 'total_moi_label'), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const Spacer(),
                Text('₹${_total.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 24,
                        fontWeight: FontWeight.w700, fontFamily: 'Inter')),
              ],
            ),
          ),
          Expanded(
            child: _records.isEmpty
                ? Center(child: Text(AppLocale.s(context, 'no_moi_records'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14,
                        color: cs.onSurface.withOpacity(0.4))))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
                    itemCount: _records.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final r = _records[i];
                      return ListTile(
                        title: Text(r['name'] as String? ?? '',
                            style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600)),
                        subtitle: Text(r['occasion'] as String? ?? '',
                            style: TextStyle(fontSize: 13,
                                color: cs.onSurface.withOpacity(0.55))),
                        trailing: Text('₹${(r['amount'] as double? ?? 0).toStringAsFixed(0)}',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 16,
                                fontWeight: FontWeight.w700, color: Color(0xFFC4520F))),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(AppLocale.s(context, 'delete_confirm_title')),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocale.s(context, 'delete_no'))),
                                TextButton(
                                  onPressed: () {
                                    _box.deleteAt(i); setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocale.s(context, 'delete_yes'), style: const TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
