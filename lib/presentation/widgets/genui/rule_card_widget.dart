import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

class RuleCardWidget extends StatelessWidget {
  final RuleCardComponentEntity component;

  const RuleCardWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color severityColor;
    IconData severityIcon;

    switch (component.severity) {
      case 'critical':
        severityColor = Colors.redAccent;
        severityIcon = Icons.error_outline;
        break;
      case 'warning':
        severityColor = Colors.amber.shade700;
        severityIcon = Icons.warning_amber_rounded;
        break;
      case 'info':
      default:
        severityColor = theme.colorScheme.primary;
        severityIcon = Icons.menu_book_rounded;
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E222A) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: severityColor.withAlpha(70),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: severityColor.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: severityColor.withAlpha(35),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(severityIcon, color: severityColor, size: 22.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    component.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: severityColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: severityColor.withAlpha(80)),
                  ),
                  child: Text(
                    component.badge,
                    style: TextStyle(
                      color: severityColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (component.steps.isNotEmpty) ...[
              SizedBox(height: 14.h),
              const Divider(height: 1),
              SizedBox(height: 12.h),
              ...component.steps.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final step = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22.w,
                        height: 22.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: severityColor.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$index',
                          style: TextStyle(
                            color: severityColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          step,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13.5.sp,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
