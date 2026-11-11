import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

class TurnCarouselWidget extends StatefulWidget {
  final TurnCarouselComponentEntity component;

  const TurnCarouselWidget({super.key, required this.component});

  @override
  State<TurnCarouselWidget> createState() => _TurnCarouselWidgetState();
}

class _TurnCarouselWidgetState extends State<TurnCarouselWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final phases = widget.component.phases;

    if (phases.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2430) : const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cached_rounded, color: theme.colorScheme.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Secuencia de Turno (${phases.length} Fases)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              Text(
                '${_currentIndex + 1}/${phases.length}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 110.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: phases.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final phase = phases[index];
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF262D3D) : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Fase ${phase.phaseNumber}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              phase.phaseName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Expanded(
                        child: Text(
                          phase.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.5.sp,
                            height: 1.35,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (phases.length > 1) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(phases.length, (idx) {
                final isSelected = idx == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: isSelected ? 16.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
