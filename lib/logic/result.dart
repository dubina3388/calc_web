sealed class OpResult {
  const OpResult();
}

class OpSuccess extends OpResult {
  final String expression;
  final String value;
  const OpSuccess(this.expression, this.value);
}

class OpFailure extends OpResult {
  final String message;
  const OpFailure(this.message);
}

double? parseNumber(String? raw) {
  if (raw == null) return null;
  final value = double.tryParse(raw.trim().replaceAll(',', '.'));
  if (value == null || value.isNaN || value.isInfinite) return null;
  return value;
}

String formatNumber(double value, {int digits = 6}) {
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toStringAsFixed(0);
  }
  var text = value.toStringAsFixed(digits);
  text = text.replaceFirst(RegExp(r'0+$'), '');
  text = text.replaceFirst(RegExp(r'\.$'), '');
  return text == '-0' ? '0' : text;
}
