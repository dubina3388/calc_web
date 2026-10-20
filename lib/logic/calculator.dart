import 'result.dart';

const operations = ['+', '-', '*', '/'];

OpResult calculate(String? rawA, String? rawOp, String? rawB) {
  if (rawA == null || rawB == null || rawOp == null) {
    return const OpFailure(
      'В адресе отсутствует обязательный параметр (a, op или b)',
    );
  }
  final a = parseNumber(rawA);
  final b = parseNumber(rawB);
  if (a == null || b == null) {
    return const OpFailure('В адресе переданы не числа');
  }
  if (!operations.contains(rawOp)) {
    return OpFailure('Неизвестная операция: «$rawOp»');
  }
  if (rawOp == '/' && b == 0) {
    return const OpFailure('Деление на ноль невозможно');
  }
  final value = switch (rawOp) {
    '+' => a + b,
    '-' => a - b,
    '*' => a * b,
    _ => a / b,
  };
  return OpSuccess(
    '${formatNumber(a)} $rawOp ${formatNumber(b)}',
    formatNumber(value),
  );
}
