import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

class QuickActionChipsWidget extends StatelessWidget {
  final QuickActionsComponentEntity component;
  final void Function(String question)? onChipTap;

  const QuickActionChipsWidget({
    super.key,
    required this.component,
    this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (component.chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 16.sp,
                color: Colors.amber.shade700,
              ),
              SizedBox(width: 6.w),
              Text(
                'Dudas frecuentes relacionadas',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: component.chips.map((chipText) {
              return ActionChip(
                elevation: 0,
                pressElevation: 2,
                avatar: Icon(
                  Icons.help_outline_rounded,
                  size: 15.sp,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  chipText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: theme.colorScheme.primary.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withAlpha(60),
                    width: 1,
                  ),
                ),
                onPressed: () {
                  if (onChipTap != null) {
                    onChipTap!(chipText);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
