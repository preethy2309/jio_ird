import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyOrdersShimmer extends StatelessWidget {
  const MyOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: 4, // show 4 placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              padding: const EdgeInsets.all(16),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
