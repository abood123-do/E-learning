import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AllOrdersShimmer extends StatelessWidget {
  const AllOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Column(
        children: List.generate(
      4,
      (index) => Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          height: mediaQuery.height / 4,
          width: mediaQuery.width,
          margin: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 30,
              vertical: mediaQuery.height / 190),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
      ),
    ));
  }
}
