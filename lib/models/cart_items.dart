// lib/models/cart_item.dart
class CartItem {
  final String id; // product id
  final String title;
  final double unitPrice;
  final int quantity;
  final String? size; // variant
  final String? ingredient; // variant
  final String? image; // asset or url

  const CartItem({
    required this.id,
    required this.title,
    required this.unitPrice,
    required this.quantity,
    this.size,
    this.ingredient,
    this.image,
  });

  String get variantKey => '${id}__${size ?? "-"}__${ingredient ?? "-"}';
  double get total => unitPrice * quantity;

  CartItem copyWith({
    String? id,
    String? title,
    double? unitPrice,
    int? quantity,
    String? size,
    String? ingredient,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      ingredient: ingredient ?? this.ingredient,
      image: image ?? this.image,
    );
  }
}
