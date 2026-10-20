import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/currency.dart';
import '../logic/result.dart';
import '../widgets/app_scaffold.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  static const _fromKey = 'converter_from';
  static const _toKey = 'converter_to';

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _from = 'USD';
  String _to = 'RUB';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _restorePair();
  }

  Future<void> _restorePair() async {
    final prefs = await SharedPreferences.getInstance();
    final from = prefs.getString(_fromKey);
    final to = prefs.getString(_toKey);
    if (!mounted) return;
    setState(() {
      if (ratesToRub.containsKey(from)) _from = from!;
      if (ratesToRub.containsKey(to)) _to = to!;
      _loaded = true;
    });
  }

  Future<void> _savePair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fromKey, _from);
    await prefs.setString(_toKey, _to);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите сумму';
    final amount = parseNumber(value);
    if (amount == null) return 'Это не число';
    if (amount < 0) return 'Сумма не может быть отрицательной';
    return null;
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
    _savePair();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final uri = Uri(
      path: '/converter/result',
      queryParameters: {
        'amount': _amountController.text.trim().replaceAll(',', '.'),
        'from': _from,
        'to': _to,
      },
    );
    context.go(uri.toString());
  }

  Widget _currencyField(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: ratesToRub.keys
          .map(
            (code) => DropdownMenuItem(
              value: code,
              child: Text(
                '$code — ${currencyNames[code]}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v == null) return;
        onChanged(v);
        _savePair();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Конвертер валют',
      child: !_loaded
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Сумма',
                      border: OutlineInputBorder(),
                    ),
                    validator: _amountValidator,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  _currencyField(
                    'Из валюты',
                    _from,
                    (v) => setState(() => _from = v),
                  ),
                  IconButton(
                    tooltip: 'Поменять местами',
                    icon: const Icon(Icons.swap_vert),
                    onPressed: _swap,
                  ),
                  _currencyField(
                    'В валюту',
                    _to,
                    (v) => setState(() => _to = v),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Конвертировать'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
