library jio_ird;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/data/models/guest_info.dart';
import 'package:jio_ird/src/providers/external_providers.dart';

import 'focus_theme.dart';
import 'jio_ird_app.dart';

class JioIRDScreen extends StatelessWidget {
  final FocusTheme focusTheme;
  final String baseUrl;
  final String accessToken;
  final String serialNumber;
  final GuestInfo guestInfo;
  final String menuTitle;
  final Widget? bottomBar;
  final Function(String event, dynamic data)? onSocketEvent;
  final String? backgroundImage;
  final String? hotelLogo;

  const JioIRDScreen({
    super.key,
    required this.focusTheme,
    required this.baseUrl,
    required this.accessToken,
    required this.serialNumber,
    required this.guestInfo,
    this.menuTitle = "In Room Dining",
    this.bottomBar,
    this.onSocketEvent,
    this.backgroundImage,
    this.hotelLogo,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        baseUrlProvider.overrideWithValue(baseUrl),
        accessTokenProvider.overrideWithValue(accessToken),
        serialNumberProvider.overrideWithValue(serialNumber),
        guestDetailsProvider.overrideWithValue(guestInfo),
        socketEventProvider.overrideWithValue(onSocketEvent),
        menuTitleProvider.overrideWithValue(menuTitle),
        focusThemeProvider.overrideWithValue(focusTheme),
        bottomBarProvider.overrideWithValue(bottomBar),
        backgroundImageRawProvider.overrideWithValue(backgroundImage),
        hotelLogoRawProvider.overrideWithValue(hotelLogo),
      ],
      child: const JioIRDApp(),
    );
  }
}
