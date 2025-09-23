import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/dish_with_quantity.dart';
import '../constants/jio_ird_events.dart';
import '../services/event_bus.dart';

class CartNotifier extends StateNotifier<List<DishWithQuantity>> {
  static const _cartKey = "cart_items";
  StreamSubscription<Map<String, dynamic>>? _subscription;

  CartNotifier() : super([]) {
    _loadCart();
    _listenToEvents();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cartKey);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      state = decoded.map((e) => DishWithQuantity.fromJson(e)).toList();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, jsonString);
  }

  void _listenToEvents() {
    _subscription = JioIRDEventBus.instance.stream.listen((event) {
      if (event[JioIRDEvents.eventName] == JioIRDEvents.clearCart) {
        clearCart();
      }
    });
  }

  void addItem(DishWithQuantity newItem) {
    final index = state.indexWhere((item) => item.dish.id == newItem.dish.id);
    if (index != -1) {
      increment(index);
    } else {
      state = [...state, newItem];
      _saveCart();
    }
  }

  void increment(int index) {
    final updatedItem = state[index].copyWith(
      quantity: state[index].quantity + 1,
    );
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedItem else state[i]
    ];
    _saveCart();
  }

  void decrement(int index) {
    if (index < 0 || index >= state.length) return;

    final item = state[index];
    if (item.quantity <= 1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i != index) state[i]
      ];
    } else {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) item.copyWith(quantity: item.quantity - 1) else state[i]
      ];
    }
    _saveCart();
  }

  void updateCookingInstruction(int dishId, String text) {
    state = state.map((item) {
      if (item.dish.id == dishId) {
        return item.copyWith(cookingRequest: text);
      }
      return item;
    }).toList();
    _saveCart();
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}