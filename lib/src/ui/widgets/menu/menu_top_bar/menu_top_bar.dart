import 'package:flutter/material.dart';
import 'package:jio_ird/src/ui/widgets/menu/menu_top_bar/profile_icon.dart';

import '../../header.dart';

class MenuTopBar extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget>? icons;

  const MenuTopBar({
    super.key,
    required this.title,
    required this.description,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Header(
            title: title,
            description: description,
          ),
          const Spacer(),
          if (icons != null && icons!.isNotEmpty) ...[
            Row(
              children: [
                for (var icon in icons!) ...[
                  icon,
                  const SizedBox(width: 16),
                ],
              ],
            ),
          ],
          const ProfileIcon(),
        ],
      ),
    );
  }
}
