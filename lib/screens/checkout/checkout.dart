import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/models/cart_items.dart';
import 'package:go_router/go_router.dart';
import 'package:foodapp/core/auth_storage.dart';
import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/providers/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loadingMe = true;
  bool _placing = false;

  // Payment methods
  String _paymentMethod = 'card'; // card | transfer | cod

  // Fees (adjust to your business rules)
  static const double vatRate = 0.075; // 7.5% VAT
  static const double deliveryFeeBase = 1200; // ₦
  static const double freeDeliveryThreshold = 8000; // ₦

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  Future<void> _prefillFromProfile() async {
    try {
      final token = await AuthStorage.readToken();
      if (token == null || token.isEmpty) {
        setState(() => _loadingMe = false);
        return;
      }
      final res = await ApiService.me(token);
      if (res['success'] == true && res['data'] is Map) {
        final u = res['data'] as Map<String, dynamic>;
        _nameCtrl.text = [
          (u['first_name'] ?? '').toString().trim(),
          (u['last_name'] ?? '').toString().trim(),
        ].where((s) => s.isNotEmpty).join(' ');
        _phoneCtrl.text = (u['phone_number'] ?? '').toString();
        _addressCtrl.text = (u['address'] ?? '').toString();
      }
    } finally {
      if (mounted) setState(() => _loadingMe = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);

    final deliveryFee =
        subtotal >= freeDeliveryThreshold || subtotal == 0
            ? 0.0
            : deliveryFeeBase;
    final vat = subtotal * vatRate;
    final total = subtotal + deliveryFee + vat;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body:
          _loadingMe
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
              ? const _EmptyCheckout()
              : SafeArea(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: [
                      _Section('Delivery details'),
                      _Input(
                        label: 'Full name',
                        controller: _nameCtrl,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Enter your name'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      _Input(
                        label: 'Phone number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Enter your phone number'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      _Input(
                        label: 'Delivery address',
                        controller: _addressCtrl,
                        maxLines: 2,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Enter delivery address'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      _Section('Your order'),
                      ...items.map((e) => _OrderTile(item: e)),
                      const SizedBox(height: 8),
                      _SummaryRow(title: 'Subtotal', value: subtotal),
                      _SummaryRow(
                        title:
                            deliveryFee == 0 ? 'Delivery (FREE)' : 'Delivery',
                        value: deliveryFee,
                      ),
                      _SummaryRow(title: 'VAT (7.5%)', value: vat),
                      const Divider(height: 24),
                      _SummaryRow(
                        title: 'Total',
                        value: total,
                        bold: true,
                        big: true,
                      ),
                      const SizedBox(height: 16),

                      _Section('Payment method'),
                      _PayMethodTile(
                        title: 'Pay with card',
                        value: 'card',
                        groupValue: _paymentMethod,
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                        icon: Icons.credit_card_outlined,
                      ),
                      _PayMethodTile(
                        title: 'Bank transfer',
                        value: 'transfer',
                        groupValue: _paymentMethod,
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                        icon: Icons.account_balance_outlined,
                      ),
                      _PayMethodTile(
                        title: 'Cash on delivery',
                        value: 'cod',
                        groupValue: _paymentMethod,
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                        icon: Icons.payments_outlined,
                      ),
                      const SizedBox(height: 12),

                      _Section('Order note (optional)'),
                      _Input(
                        label: 'e.g., Please call on arrival',
                        controller: _noteCtrl,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _placing ? null : () => _placeOrder(total),
                          icon:
                              _placing
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Icon(Icons.check_circle_outline),
                          label: Text(
                            _placing ? 'Placing order...' : 'Place Order',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Future<void> _placeOrder(double total) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _placing = true);

    try {
      final items = ref.read(cartProvider);
      final payload = {
        'customer_name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'note': _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        'payment_method': _paymentMethod,
        'items':
            items
                .map(
                  (i) => {
                    'product_id': i.id,
                    'title': i.title,
                    'unit_price': i.unitPrice,
                    'quantity': i.quantity,
                    'size': i.size,
                    'ingredient': i.ingredient,
                  },
                )
                .toList(),
        'totals': {
          'subtotal': ref.read(cartTotalProvider),
          'delivery_fee':
              (ref.read(cartTotalProvider) >= freeDeliveryThreshold)
                  ? 0
                  : deliveryFeeBase,
          'vat': ref.read(cartTotalProvider) * vatRate,
          'grand_total': total,
        },
      };

      await Future.delayed(const Duration(milliseconds: 900)); // demo
      if (!mounted) return;
      ref.read(cartProvider.notifier).clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      context.push(
        '/order_successful',
        extra: {
          'orderId': 'DD-${DateTime.now().millisecondsSinceEpoch}',
          'total': total,
          'eta': 35,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order failed: $e')));
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: scheme.surface.withOpacity(.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                if (item.size != null || item.ingredient != null)
                  Text(
                    [
                      if (item.size != null) item.size,
                      if (item.ingredient != null) item.ingredient,
                    ].join(' • '),
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(.75),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  "₦${item.unitPrice.toStringAsFixed(2)}  ×  ${item.quantity}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "₦${(item.unitPrice * item.quantity).toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    this.bold = false,
    this.big = false,
  });

  final String title;
  final double value;
  final bool bold;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
      fontSize: big ? 18 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text("₦${value.toStringAsFixed(2)}", style: style),
        ],
      ),
    );
  }
}

class _PayMethodTile extends StatelessWidget {
  const _PayMethodTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
  });

  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        secondary: Icon(icon, color: Colors.orange),
      ),
    );
  }
}

class _EmptyCheckout extends StatelessWidget {
  const _EmptyCheckout();

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
              "No items to checkout",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "Add items to your cart and return to checkout.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
