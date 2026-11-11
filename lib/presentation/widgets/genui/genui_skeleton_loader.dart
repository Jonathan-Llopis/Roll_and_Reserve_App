import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenUiSkeletonLoader extends StatelessWidget {
  const GenUiSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 12.r, backgroundColor: Colors.grey),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    height: 18.h,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 20.w),
                Container(
                  width: 50.w,
                  height: 18.h,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(height: 12.h, width: double.infinity, color: Colors.grey),
            SizedBox(height: 8.h),
            Container(height: 12.h, width: 220.w, color: Colors.grey),
            SizedBox(height: 8.h),
            Container(height: 12.h, width: 160.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
