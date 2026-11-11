import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/data/models/genui_component_model.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

void main() {
  group('RulesAssistResponseModel', () {
    test('should parse full GenUI response correctly', () {
      final json = {
        'game': {'id': 3, 'bgg_id': 13, 'name': 'Catan'},
        'summary': 'Al sacar un 7 se activa el ladrón.',
        'cached': true,
        'genui_components': [
          {
            'type': 'rule_card',
            'title': 'El Ladrón',
            'badge': 'Oficial',
            'severity': 'critical',
            'steps': ['Descarta si tienes >7 cartas', 'Mueve al ladrón'],
          },
          {
            'type': 'turn_carousel',
            'phases': [
              {
                'phaseNumber': 1,
                'phaseName': 'Producción',
                'description': 'Tira los dados',
              },
              {
                'phaseNumber': 2,
                'phaseName': 'Comercio',
                'description': 'Intercambia recursos',
              },
            ],
          },
          {
            'type': 'quick_actions',
            'chips': ['¿Cómo comerciar con la banca?'],
          },
          {
            'type': 'text_card',
            'content': 'Nota adicional',
          },
        ],
      };

      final model = RulesAssistResponseModel.fromJson(json);

      expect(model.summary, 'Al sacar un 7 se activa el ladrón.');
      expect(model.cached, true);
      expect(model.game['name'], 'Catan');
      expect(model.components.length, 4);

      expect(model.components[0], isA<RuleCardComponentEntity>());
      final ruleCard = model.components[0] as RuleCardComponentEntity;
      expect(ruleCard.title, 'El Ladrón');
      expect(ruleCard.severity, 'critical');
      expect(ruleCard.steps.length, 2);

      expect(model.components[1], isA<TurnCarouselComponentEntity>());
      final carousel = model.components[1] as TurnCarouselComponentEntity;
      expect(carousel.phases.length, 2);
      expect(carousel.phases[0].phaseName, 'Producción');

      expect(model.components[2], isA<QuickActionsComponentEntity>());
      final chips = model.components[2] as QuickActionsComponentEntity;
      expect(chips.chips.first, '¿Cómo comerciar con la banca?');

      expect(model.components[3], isA<TextCardComponentEntity>());
      final textCard = model.components[3] as TextCardComponentEntity;
      expect(textCard.content, 'Nota adicional');
    });

    test('should defensively fallback to text card on malformed component', () {
      final json = {
        'game': {'name': 'Carcassonne'},
        'summary': 'Puntuación de caminos',
        'cached': false,
        'genui_components': [
          {'type': 'unknown_type', 'content': 'Texto seguro'},
          'invalid_non_map_item',
        ],
      };

      final model = RulesAssistResponseModel.fromJson(json);

      expect(model.summary, 'Puntuación de caminos');
      expect(model.components.isNotEmpty, true);
      expect(model.components.first, isA<TextCardComponentEntity>());
    });

    test('should generate default fallback rule card if component list is empty', () {
      final json = {
        'game': {'name': 'Wingspan'},
        'summary': 'Resumen de comida',
        'cached': false,
        'genui_components': <dynamic>[],
      };

      final model = RulesAssistResponseModel.fromJson(json);

      expect(model.components.length, 1);
      expect(model.components.first, isA<RuleCardComponentEntity>());
      final ruleCard = model.components.first as RuleCardComponentEntity;
      expect(ruleCard.title, 'Regla de Wingspan');
      expect(ruleCard.steps, ['Resumen de comida']);
    });
  });
}
