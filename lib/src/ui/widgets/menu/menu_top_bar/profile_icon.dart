import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../providers/external_providers.dart';

class ProfileIcon extends ConsumerStatefulWidget {
  const ProfileIcon({super.key});

  @override
  ConsumerState<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends ConsumerState<ProfileIcon> {
  @override
  Widget build(BuildContext context) {
    final logo = ref.watch(resolvedHotelLogoProvider);

    return InkWell(
      onTap: _goToProfile,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          height: 40,
          child: logo != null
              ? Image(
            image: logo,
            fit: BoxFit.fitHeight,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              return _buildShimmer();
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'jio_ird/assets/images/hotel_logo.png',
                height: 40,
                fit: BoxFit.fitHeight,
              );
            },
          )
              : Image.asset(
            'jio_ird/assets/images/hotel_logo.png',
            height: 40,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // ✅ Same rounded corners
        ),
      ),
    );
  }

  void _goToProfile() {
    debugPrint('Profile pressed');
  }
}