// lib/providers/cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/models/cart_items.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  void clear() => state = const [];

  void addOrIncrement(CartItem newItem) {
    final key = newItem.variantKey;
    final idx = state.indexWhere((i) => i.variantKey == key);
    if (idx == -1) {
      state = [...state, newItem];
    } else {
      final existing = state[idx];
      state = [
        ...state.take(idx),
        existing.copyWith(quantity: existing.quantity + newItem.quantity),
        ...state.skip(idx + 1),
      ];
    }
  }

  void increment(String variantKey) {
    final idx = state.indexWhere((i) => i.variantKey == variantKey);
    if (idx == -1) return;
    final it = state[idx];
    state = [
      ...state.take(idx),
      it.copyWith(quantity: it.quantity + 1),
      ...state.skip(idx + 1),
    ];
  }

  void decrement(String variantKey) {
    final idx = state.indexWhere((i) => i.variantKey == variantKey);
    if (idx == -1) return;
    final it = state[idx];
    if (it.quantity <= 1) {
      remove(variantKey);
    } else {
      state = [
        ...state.take(idx),
        it.copyWith(quantity: it.quantity - 1),
        ...state.skip(idx + 1),
      ];
    }
  }

  void remove(String variantKey) {
    state = state.where((i) => i.variantKey != variantKey).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, i) => sum + i.total);
});

final cartCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, i) => sum + i.quantity);
});
