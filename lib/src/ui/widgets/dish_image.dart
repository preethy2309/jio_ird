import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'shimmer_loader.dart';

class DishImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String fallbackAsset;
  final double fallbackWidth;
  final double fallbackHeight;
  final BoxFit fit;

  const DishImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.fallbackAsset = 'jio_ird/assets/images/default.svg',
    this.fallbackWidth = 45,
    this.fallbackHeight = 45,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return ShimmerLoader(
              height: height,
              width: width,
              borderRadius: borderRadius,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallback();
          },
        ),
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[800],
        alignment: Alignment.center,
        child: SvgPicture.asset(
          fallbackAsset,
          width: fallbackWidth,
          height: fallbackHeight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}