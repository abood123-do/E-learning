import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CourseShimmer extends StatelessWidget {
  const CourseShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.6),
        itemCount: 8,
        itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.grey[300]!,
            child: Container(
              padding: EdgeInsets.all(12.w),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15.w),
              ),
            )),
      ),
    );
  }
}
