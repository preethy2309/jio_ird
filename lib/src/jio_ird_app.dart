import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/providers/external_providers.dart';

import 'ui/screens/cart_screen.dart';
import 'ui/screens/menu_screen.dart';

class JioIRDApp extends ConsumerWidget {
  const JioIRDApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusTheme = ref.watch(focusThemeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: focusTheme.focusedColor,
        colorScheme: ColorScheme.dark(
          primary: focusTheme.focusedColor,
          secondary: focusTheme.unfocusedColor,
          onPrimary: focusTheme.focusedTextColor,
          onSecondary: focusTheme.unfocusedTextColor,
        ),
        scaffoldBackgroundColor: focusTheme.unfocusedColor.withOpacity(0.9),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: focusTheme.unfocusedTextColor,
          ),
          bodyLarge: TextStyle(
            color: focusTheme.focusedTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => const MenuScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
