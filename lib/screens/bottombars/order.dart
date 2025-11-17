import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [];

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), elevation: 0.5),
      body:
          orders.isEmpty
              ? const _EmptyOrdersView()
              : _OrdersList(orders: orders),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final primaryFill = Colors.orange.shade50;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        child: Column(
          children: [
            // Hero illustration container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              decoration: BoxDecoration(
                color: primaryFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withOpacity(.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      size: 56,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When you place an order, it will appear here. You can track '
                    'your active orders and revisit your history anytime.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            context.go('/bottom');
                          },
                          icon: const Icon(Icons.restaurant_menu),
                          label: const Text('Start ordering'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.orange.shade50,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Optional: go to categories/popular dishes page
                            // e.g. context.go('/discover');
                          },
                          icon: const Icon(Icons.explore_outlined),
                          label: const Text('Explore dishes'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.orange.shade200),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _TipRow(
              icon: Icons.timeline_outlined,
              title: 'Track live status',
              subtitle: 'Follow preparation and delivery in real time.',
            ),
            const SizedBox(height: 12),
            _TipRow(
              icon: Icons.payments_outlined,
              title: 'Keep receipts',
              subtitle: 'Download invoices for past orders when needed.',
            ),
            const SizedBox(height: 12),
            _TipRow(
              icon: Icons.support_agent,
              title: 'Get help fast',
              subtitle: 'Report any issue from your order details.',
            ),
          ],
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<Map<String, dynamic>> orders;

  @override
  Widget build(BuildContext context) {
    // Placeholder list UI (for when you start having orders)
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final o = orders[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange.shade50, // primary accent
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o['title'] ?? 'Order',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      o['subtitle'] ?? 'Items • Restaurant • Time',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(.75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                o['status'] ?? 'Completed',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right),
            ],
          ),
        );
      },
    );
  }
}
