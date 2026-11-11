import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/data/models/functions_for_models.dart';

void main() {
  group('functions_for_models', () {
    test('calcularMediaRatings handles integers correctly', () {
      final reviews = [
        {'raiting': 4},
        {'raiting': 5},
      ];
      expect(calcularMediaRatings(reviews), 4.5);
    });

    test('calcularMediaRatings handles doubles and rating key variations', () {
      final reviews = [
        {'raiting': 3.5},
        {'rating': 4.5},
      ];
      expect(calcularMediaRatings(reviews), 4.0);
    });

    test('calcularMediaRatings handles empty list', () {
      expect(calcularMediaRatings([]), 0.0);
    });

    test('calcularMediaRatings ignores invalid items', () {
      final reviews = [
        'invalid item',
        {'raiting': null},
        {'raiting': 5},
      ];
      expect(calcularMediaRatings(reviews), 5.0);
    });

    test('getDate formats date correctly and handles short strings safely', () {
      expect(getDate('2024-11-20T18:00:00Z'), '20 - 11 - 2024');
      expect(getDate('short'), 'short');
    });

    test('getHour formats hour correctly and handles short strings safely', () {
      expect(getHour('2024-11-20T18:30:00Z'), '18:30');
      expect(getHour('short'), '');
    });

    test('calcularMesasTienda extracts IDs safely', () {
      final tables = [
        {'id_table': 1},
        {'id_table': 2},
        {'id_table': null},
      ];
      expect(calcularMesasTienda(tables), [1, 2]);
    });
  });
}
