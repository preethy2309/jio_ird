import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/providers/focus_provider.dart';
import 'package:jio_ird/src/providers/navigator_observer.dart';
import 'package:jio_ird/src/providers/state_provider.dart';
import 'package:jio_ird/src/ui/screens/order_detail_screen.dart';
import 'package:jio_ird/src/utils/helper.dart';

import 'providers/external_providers.dart';
import 'ui/screens/cart_screen.dart';
import 'ui/screens/menu_screen.dart';

final GlobalKey<NavigatorState> moduleNavigatorKey =
    GlobalKey<NavigatorState>();

class JioIRDModule extends ConsumerWidget {
  const JioIRDModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusTheme = ref.watch(focusThemeProvider);

    final theme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: focusTheme.focusedColor,
      colorScheme: ColorScheme.dark(
        primary: focusTheme.focusedColor,
        secondary: focusTheme.unfocusedColor,
        onPrimary: focusTheme.focusedTextColor,
        onSecondary: focusTheme.unfocusedTextColor,
        tertiary: focusTheme.titleColor,
      ),
      scaffoldBackgroundColor: focusTheme.unfocusedColor.withOpacity(0.9),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: focusTheme.unfocusedTextColor),
        bodyLarge: TextStyle(
          color: focusTheme.focusedTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () async {
          final isMenuScreen = ref.read(currentRouteProvider) == '/menu';
          if (isMenuScreen) {
            debugPrint("Preethy : 11 ${ref.read(isDishFocusedProvider)}  ${ref.read(isSubCategoryListFocusedProvider)} ${ref.read(isCategoryFocusedProvider)}");
            if (ref.read(isDishFocusedProvider)) {
              debugPrint("Preethy : 22");
              if (hasSubCategories(ref)) {
                debugPrint("Preethy : 33");
                ref.read(showSubCategoriesProvider.notifier).state = true;
                ref.read(focusedDishProvider.notifier).state = -1;
              } else {
                debugPrint("Preethy : 44");
                ref.read(showCategoriesProvider.notifier).state = true;
              }
              return false;
            }

            if (ref.read(isSubCategoryListFocusedProvider)) {
              debugPrint("Preethy : 55");
              ref.read(showCategoriesProvider.notifier).state = true;
              ref.read(selectedSubCategoryProvider.notifier).state = -1;
              ref.read(isCategoryFocusedProvider.notifier).state = true;
              return false;
            }

            if (ref.read(isCategoryFocusedProvider) ||
                ref.read(vegToggleFocusNodeProvider).hasFocus ||
                ref.read(goToCartFocusNodeProvider).hasFocus) {
              debugPrint("Preethy : 66");
              Navigator.of(context).pop();
              return true;
            }
          }

          if (moduleNavigatorKey.currentState?.canPop() ?? false) {
            debugPrint("Preethy : 77");
            moduleNavigatorKey.currentState!.pop();
            return false;
          }
          debugPrint("Preethy : 88");
          return true;
        },
        child: Navigator(
          key: moduleNavigatorKey,
          observers: [ModuleNavigatorObserver(ref)],
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/menu':
                return MaterialPageRoute(
                  builder: (_) => const MenuScreen(),
                  settings: settings,
                );
              case '/cart':
                return MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                  settings: settings,
                );
              case '/orderDetail':
                final args = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => OrderDetailScreen(orderId: args),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const MenuScreen(),
                  settings: const RouteSettings(name: '/menu'),
                );
            }
          },
        ),
      ),
    );
  }
}
