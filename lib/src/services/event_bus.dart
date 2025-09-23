import 'dart:async';

class JioIRDEventBus {
  JioIRDEventBus._();
  static final JioIRDEventBus instance = JioIRDEventBus._();

  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void emit(String event, {dynamic data}) {
    _controller.add({"event": event, "data": data});
  }
}