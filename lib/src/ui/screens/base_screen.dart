import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/external_providers.dart';
import '../widgets/menu/menu_top_bar/menu_top_bar.dart';

class BaseScreen extends ConsumerWidget {
  final String title;
  final List<Widget>? icons;
  final Widget child;

  const BaseScreen({
    super.key,
    required this.title,
    this.icons,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBar = ref.watch(bottomBarProvider);
    final guestInfo = ref.watch(guestDetailsProvider);
    final bgImage = ref.watch(resolvedBackgroundImageProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: bgImage != null
                ? Image(
                    image: bgImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'jio_ird/assets/images/bg.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'jio_ird/assets/images/bg.png',
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 38,
              right: 32,
              top: 26,
              bottom: bottomBar != null ? 40.0 : 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuTopBar(
                  title: title,
                  description: "Room No : ${guestInfo.roomNo}" ?? "",
                  icons: icons,
                ),
                const SizedBox(height: 20),
                Expanded(child: child),
              ],
            ),
          ),
          if (bottomBar != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: bottomBar,
            ),
        ],
      ),
      backgroundColor: const Color(0x80000000),
    );
  }
}
