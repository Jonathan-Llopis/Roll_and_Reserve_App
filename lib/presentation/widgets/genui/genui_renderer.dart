import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';
import 'package:roll_and_reserve/presentation/widgets/genui/quick_action_chips_widget.dart';
import 'package:roll_and_reserve/presentation/widgets/genui/rule_card_widget.dart';
import 'package:roll_and_reserve/presentation/widgets/genui/text_card_widget.dart';
import 'package:roll_and_reserve/presentation/widgets/genui/turn_carousel_widget.dart';

class GenUiRenderer extends StatelessWidget {
  final List<GenUiComponentEntity> components;
  final String? summary;
  final bool isCached;
  final void Function(String question)? onChipTap;

  const GenUiRenderer({
    super.key,
    required this.components,
    this.summary,
    this.isCached = false,
    this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (summary != null && summary!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 6.h, top: 4.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    summary!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
                if (isCached)
                  Tooltip(
                    message: 'Respuesta instantánea recuperada de la caché local',
                    child: Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Icon(
                        Icons.bolt_rounded,
                        size: 16.sp,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        ...components.map((component) {
          try {
            if (component is RuleCardComponentEntity) {
              return RuleCardWidget(component: component);
            } else if (component is TurnCarouselComponentEntity) {
              return TurnCarouselWidget(component: component);
            } else if (component is QuickActionsComponentEntity) {
              return QuickActionChipsWidget(
                component: component,
                onChipTap: onChipTap,
              );
            } else if (component is TextCardComponentEntity) {
              return TextCardWidget(component: component);
            }
            return TextCardWidget(
              component: TextCardComponentEntity(content: component.toString()),
            );
          } catch (e) {
            // Protección contra fallos de renderizado de componentes
            return TextCardWidget(
              component: TextCardComponentEntity(
                content: 'Detalle de regla: ${component.toString()}',
              ),
            );
          }
        }),
      ],
    );
  }
}
