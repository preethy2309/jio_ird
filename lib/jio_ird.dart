library jio_ird;

import 'package:shared_preferences/shared_preferences.dart';

import 'src/services/event_bus.dart';
import 'src/constants/jio_ird_events.dart';

export 'src/focus_theme.dart';
export 'src/jio_ird_screen.dart';
export 'src/data/models/guest_info.dart';
export 'src/services/event_bus.dart';
export 'src/constants/jio_ird_events.dart';

class JioIRD {
  static Future<void> clearCart() async {
    JioIRDEventBus.instance.emit(JioIRDEvents.clearCart);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('_clear_cart_flag', true);
  }

  static void orderPlaced(dynamic data) {
    JioIRDEventBus.instance.emit(
      JioIRDEvents.orderStatus
    );
  }

  static Stream<Map<String, dynamic>> get events =>
      JioIRDEventBus.instance.stream;
}
