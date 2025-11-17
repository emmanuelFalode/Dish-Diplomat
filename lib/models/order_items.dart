class OrderItem {
  final String title;
  final String? size;
  final String? ingredient;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.title,
    this.size,
    this.ingredient,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => unitPrice * quantity;
}

class Order {
  final String id; 
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double vat;
  final double total;
  final String status; 
  final DateTime placedAt;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.vat,
    required this.total,
    required this.status,
    required this.placedAt,
  });
}
