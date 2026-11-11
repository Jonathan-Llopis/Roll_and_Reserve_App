import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

class TextCardWidget extends StatelessWidget {
  final TextCardComponentEntity component;

  const TextCardWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232832) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      child: Text(
        component.content,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 13.5.sp,
          height: 1.4,
        ),
      ),
    );
  }
}
