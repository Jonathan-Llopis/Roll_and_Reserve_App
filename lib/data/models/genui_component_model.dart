import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

class RulesAssistResponseModel extends RulesAssistResponseEntity {
  const RulesAssistResponseModel({
    required super.game,
    required super.summary,
    required super.components,
    super.cached = false,
  });

  factory RulesAssistResponseModel.fromJson(Map<String, dynamic> json) {
    final gameMap = json['game'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['game'] as Map)
        : <String, dynamic>{'name': 'Juego'};

    final summaryStr = json['summary']?.toString() ?? '';
    final cachedVal = json['cached'] == true;

    final rawComponents = json['genui_components'] as List<dynamic>? ?? [];
    final List<GenUiComponentEntity> parsedComponents = [];

    for (final raw in rawComponents) {
      if (raw is! Map<String, dynamic>) continue;

      try {
        final type = raw['type']?.toString();

        if (type == 'rule_card') {
          final stepsList = (raw['steps'] as List<dynamic>?)
                  ?.map((s) => s.toString())
                  .toList() ??
              [];
          parsedComponents.add(
            RuleCardComponentEntity(
              title: raw['title']?.toString() ?? 'Regla',
              badge: raw['badge']?.toString() ?? 'Oficial',
              severity: raw['severity']?.toString() ?? 'info',
              steps: stepsList,
            ),
          );
        } else if (type == 'turn_carousel') {
          final rawPhases = (raw['phases'] as List<dynamic>?) ?? [];
          final phasesList = rawPhases
              .map((p) {
                if (p is Map<String, dynamic>) {
                  return TurnPhaseEntity(
                    phaseNumber: p['phaseNumber'] is int
                        ? p['phaseNumber'] as int
                        : int.tryParse(p['phaseNumber']?.toString() ?? '') ?? 1,
                    phaseName: p['phaseName']?.toString() ?? 'Fase',
                    description: p['description']?.toString() ?? '',
                  );
                }
                return const TurnPhaseEntity(
                  phaseNumber: 1,
                  phaseName: 'Fase',
                  description: '',
                );
              })
              .toList();
          parsedComponents.add(TurnCarouselComponentEntity(phases: phasesList));
        } else if (type == 'quick_actions') {
          final chipsList = (raw['chips'] as List<dynamic>?)
                  ?.map((c) => c.toString())
                  .toList() ??
              [];
          parsedComponents.add(QuickActionsComponentEntity(chips: chipsList));
        } else if (type == 'text_card') {
          parsedComponents.add(
            TextCardComponentEntity(
              content: raw['content']?.toString() ?? '',
            ),
          );
        } else {
          // Componente no reconocido: fallback defensivo
          parsedComponents.add(
            TextCardComponentEntity(
              content: raw['content']?.toString() ?? raw.toString(),
            ),
          );
        }
      } catch (_) {
        // En caso de fallo en un componente individual, rescatar contenido en texto plano
        parsedComponents.add(
          TextCardComponentEntity(content: raw.toString()),
        );
      }
    }

    // Si la lista de componentes está vacía, generar tarjeta por defecto con el summary
    if (parsedComponents.isEmpty) {
      parsedComponents.add(
        RuleCardComponentEntity(
          title: 'Regla de ${gameMap['name'] ?? 'Juego'}',
          badge: 'Regla General',
          severity: 'info',
          steps: [summaryStr],
        ),
      );
    }

    return RulesAssistResponseModel(
      game: gameMap,
      summary: summaryStr,
      components: parsedComponents,
      cached: cachedVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game': game,
      'summary': summary,
      'cached': cached,
      'genui_components': components.map((c) {
        if (c is RuleCardComponentEntity) {
          return {
            'type': 'rule_card',
            'title': c.title,
            'badge': c.badge,
            'severity': c.severity,
            'steps': c.steps,
          };
        } else if (c is TurnCarouselComponentEntity) {
          return {
            'type': 'turn_carousel',
            'phases': c.phases
                .map(
                  (p) => {
                    'phaseNumber': p.phaseNumber,
                    'phaseName': p.phaseName,
                    'description': p.description,
                  },
                )
                .toList(),
          };
        } else if (c is QuickActionsComponentEntity) {
          return {
            'type': 'quick_actions',
            'chips': c.chips,
          };
        } else if (c is TextCardComponentEntity) {
          return {
            'type': 'text_card',
            'content': c.content,
          };
        }
        return {'type': c.type};
      }).toList(),
    };
  }
}
