import 'package:calc_web/logic/calculator.dart';
import 'package:calc_web/logic/currency.dart';
import 'package:calc_web/logic/result.dart';
import 'package:flutter_test/flutter_test.dart';

String valueOf(OpResult r) => (r as OpSuccess).value;
String errorOf(OpResult r) => (r as OpFailure).message;

void main() {
  group('calculate', () {
    test('сложение', () => expect(valueOf(calculate('2', '+', '3')), '5'));
    test('вычитание', () => expect(valueOf(calculate('10', '-', '15')), '-5'));
    test('умножение', () => expect(valueOf(calculate('2.5', '*', '4')), '10'));
    test('деление с округлением', () {
      expect(valueOf(calculate('10', '/', '3')), '3.333333');
    });
    test('запятая как разделитель', () {
      expect(valueOf(calculate('1,5', '+', '1,5')), '3');
    });
    test('деление на ноль', () {
      expect(errorOf(calculate('5', '/', '0')), contains('ноль'));
    });
    test('нечисловой ввод', () {
      expect(errorOf(calculate('abc', '+', '1')), contains('не числа'));
    });
    test('неизвестная операция', () {
      expect(errorOf(calculate('1', '%', '2')), contains('Неизвестная'));
    });
    test('отсутствует параметр', () {
      expect(errorOf(calculate('1', '+', null)), contains('отсутствует'));
    });
  });

  group('convert', () {
    test('доллары в рубли', () {
      expect(valueOf(convert('10', 'USD', 'RUB')), '925 RUB');
    });
    test('одинаковые валюты', () {
      expect(valueOf(convert('7', 'EUR', 'EUR')), '7 EUR');
    });
    test('округление до копеек', () {
      expect(valueOf(convert('100', 'RUB', 'USD')), '1.08 USD');
    });
    test('неизвестная валюта', () {
      expect(errorOf(convert('1', 'XXX', 'RUB')), contains('XXX'));
    });
    test('сумма не число', () {
      expect(errorOf(convert('сто', 'USD', 'RUB')), contains('не является'));
    });
    test('отрицательная сумма', () {
      expect(errorOf(convert('-1', 'USD', 'RUB')), contains('отрицательной'));
    });
  });

  group('formatNumber', () {
    test('целое без дробной части', () => expect(formatNumber(4.0), '4'));
    test('обрезает хвост нулей', () => expect(formatNumber(0.1 + 0.2), '0.3'));
  });
}
