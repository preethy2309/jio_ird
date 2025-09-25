import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/providers/state_provider.dart';

class ModuleNavigatorObserver extends NavigatorObserver {
  final WidgetRef ref;

  ModuleNavigatorObserver(this.ref);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("Udpating route value here Preethy ${route.settings.name}");
      ref.read(currentRouteProvider.notifier).state = route.settings.name ?? '';
    });
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("Udpating route value here Preethy 2 ${previousRoute?.settings.name}");
      ref.read(currentRouteProvider.notifier).state = previousRoute?.settings.name ?? '';
    });
  }
}
