import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryFocusNodeProvider =
    Provider.family.autoDispose<FocusNode, int>((ref, index) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final dishFocusNodeProvider =
    Provider.family.autoDispose<FocusNode, int>((ref, index) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final subCategoryFocusNodeProvider =
Provider.family.autoDispose<FocusNode, int>((ref, index) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final subCategoryMainFocusNodeProvider =
Provider.family.autoDispose<FocusNode, int>((ref, index) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final cartTabFocusNodeProvider = Provider<FocusNode>((ref) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final myOrdersTabFocusNodeProvider = Provider<FocusNode>((ref) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});


final vegToggleFocusNodeProvider = Provider<FocusNode>((ref) {
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final cookingInstructionFocusNodeProvider =
Provider.autoDispose<FocusNode>((ref) {
  final node = FocusNode(debugLabel: "CookingInstruction");
  ref.onDispose(node.dispose);
  return node;
});

final placeOrderFocusNodeProvider =
Provider.autoDispose<FocusNode>((ref) {
  final node = FocusNode(debugLabel: "PlaceOrder");
  ref.onDispose(node.dispose);
  return node;
});
