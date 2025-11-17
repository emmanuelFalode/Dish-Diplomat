// lib/screens/cart/cart.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/models/cart_items.dart';
import 'package:foodapp/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

class Cart extends ConsumerWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: 'Clear cart',
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body:
          items.isEmpty
              ? const _EmptyCart()
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final it = items[i];
                        return _CartTile(item: it);
                      },
                    ),
                  ),
                  _BottomBar(total: total),
                ],
              ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.orange.shade800,
            ),
            const SizedBox(height: 12),
            const Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "Add delicious meals and they’ll appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(.75),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            image:
                (item.image != null)
                    ? DecorationImage(
                      image: AssetImage(item.image!),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              item.image == null
                  ? Icon(Icons.fastfood, color: Colors.orange.shade800)
                  : null,
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.size != null || item.ingredient != null)
              Text(
                [
                  if (item.size != null) item.size,
                  if (item.ingredient != null) item.ingredient,
                ].join(' • '),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(.8),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              "₦${item.unitPrice.toStringAsFixed(2)}  •  Total: ₦${item.total.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: _QtyControls(variantKey: item.variantKey, qty: item.quantity),
      ),
    );
  }
}

class _QtyControls extends ConsumerWidget {
  const _QtyControls({required this.variantKey, required this.qty});
  final String variantKey;
  final int qty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _roundIcon(
          icon: Icons.remove,
          onTap: () => ref.read(cartProvider.notifier).decrement(variantKey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$qty',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        _roundIcon(  
          icon: Icons.add,
          filled: true,
          onTap: () => ref.read(cartProvider.notifier).increment(variantKey),
        ),
        const SizedBox(width: 6),
        IconButton(
          tooltip: 'Remove',
          onPressed: () => ref.read(cartProvider.notifier).remove(variantKey),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  Widget _roundIcon({
    required IconData icon,
    bool filled = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: filled ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange),
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : Colors.orange,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.total});
  final double total;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₦${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push("/checkout");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceed to checkout')),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text(
                  "Checkout",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
