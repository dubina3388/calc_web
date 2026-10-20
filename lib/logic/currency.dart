import 'result.dart';

const ratesToRub = <String, double>{
  'RUB': 1,
  'USD': 92.5,
  'EUR': 100.2,
  'CNY': 12.7,
  'GBP': 117.4,
  'KZT': 0.19,
  'TRY': 2.8,
};

const currencyNames = <String, String>{
  'RUB': 'Российский рубль',
  'USD': 'Доллар США',
  'EUR': 'Евро',
  'CNY': 'Китайский юань',
  'GBP': 'Фунт стерлингов',
  'KZT': 'Казахстанский тенге',
  'TRY': 'Турецкая лира',
};

OpResult convert(String? rawAmount, String? from, String? to) {
  if (rawAmount == null || from == null || to == null) {
    return const OpFailure(
      'В адресе отсутствует обязательный параметр (amount, from или to)',
    );
  }
  final amount = parseNumber(rawAmount);
  if (amount == null) {
    return const OpFailure('Сумма в адресе не является числом');
  }
  if (amount < 0) {
    return const OpFailure('Сумма не может быть отрицательной');
  }
  final fromRate = ratesToRub[from];
  final toRate = ratesToRub[to];
  if (fromRate == null || toRate == null) {
    return OpFailure('Неизвестная валюта: «${fromRate == null ? from : to}»');
  }
  final value = amount * fromRate / toRate;
  return OpSuccess(
    '${formatNumber(amount, digits: 2)} $from → $to',
    '${formatNumber(value, digits: 2)} $to',
  );
}
