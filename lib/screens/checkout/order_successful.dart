import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessPage extends StatefulWidget {
  final String orderId;
  final double? total;
  final int etaMinutes;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    this.total,
    this.etaMinutes = 35,
  });

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalText =
        widget.total != null ? '₦${widget.total!.toStringAsFixed(2)}' : '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          children: [
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _ctrl,
                  curve: Curves.easeOutBack,
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange.shade200, width: 2),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 74,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Order Successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Thanks for your order. We're getting it ready.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(.8),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Column(
                children: [
                  _row('Order ID', widget.orderId, copyable: true),
                  const SizedBox(height: 10),
                  _row('Estimated Time', '~ ${widget.etaMinutes} mins'),
                  const SizedBox(height: 10),
                  _row('Total', totalText, bold: true),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Actions
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
                onPressed: () => context.go('/orders'), 
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text(
                  'Track Order',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.orange.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.go('/bottom'),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.orange.shade800,
                ),
                const SizedBox(width: 6),
                Text(
                  'You’ll get updates as your order moves.',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool bold = false,
    bool copyable = false,
  }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
      fontSize: bold ? 16 : 14,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(title, style: style)),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Copy',
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: value));
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order ID copied')),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
