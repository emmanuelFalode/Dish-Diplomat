import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/models/cart_items.dart';
import 'package:go_router/go_router.dart';
import 'package:foodapp/widgets/color_extension.dart';
import 'package:foodapp/providers/cart_provider.dart';

class ItemsDetails extends ConsumerStatefulWidget {
  const ItemsDetails({super.key});

  @override
  ConsumerState<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends ConsumerState<ItemsDetails> {
  final double basePrice = 15000;
  String? selectedSize;
  String? selectedIngredient;
  int quantity = 1;

  // Price adjustments
  final Map<String, double> sizePrices = {"Small": 300, "Big": 500};

  final Map<String, double> ingredientPrices = {
    "Cheese": 1700,
    "Onion": 1000,
    "Tomato": 2000,
    "Chicken": 3500,
  };

  double get unitPrice {
    double extra = 0;
    if (selectedSize != null) extra += sizePrices[selectedSize] ?? 0;
    if (selectedIngredient != null) {
      extra += ingredientPrices[selectedIngredient] ?? 0;
    }
    return basePrice + extra;
  }

  double get totalPrice => unitPrice * quantity;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              "assets/images/pizza.jpg",
              width: media.width,
              height: media.width,
              fit: BoxFit.cover,
            ),
            Container(
              width: media.width,
              height: media.height,
              color: Colors.black.withOpacity(0.1),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.push("/cart"),
                          icon: const Icon(
                            Icons.shopping_cart,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: media.width - 60,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 35),
                            _buildTitle("Tandoori Chicken Pizza"),
                            const SizedBox(height: 8),
                            _buildRatingAndPrice(),
                            const SizedBox(height: 15),
                            _buildSectionTitle("Description"),
                            const SizedBox(height: 15),
                            _buildDescription(),
                            const SizedBox(height: 20),
                            _buildDivider(),
                            const SizedBox(height: 20),
                            _buildSectionTitle("Customize your order"),
                            const SizedBox(height: 15),
                            _buildDropdown(
                              label: "-Select the size of portion-",
                              value: selectedSize,
                              items: sizePrices.keys.toList(),
                              onChanged:
                                  (val) => setState(() => selectedSize = val),
                            ),
                            const SizedBox(height: 15),
                            _buildDropdown(
                              label: "-Select the Ingredients-",
                              value: selectedIngredient,
                              items: ingredientPrices.keys.toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => selectedIngredient = val),
                            ),
                            const SizedBox(height: 20),
                            _buildPortionCounter(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      text,
      style: TextStyle(
        color: Tcolor.primaryText,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  Widget _buildRatingAndPrice() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IgnorePointer(
              ignoring: true,
              child: RatingBar.builder(
                initialRating: 4,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 25,
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Tcolor.primary),
                onRatingUpdate: (_) {},
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "4 Star Ratings",
              style: TextStyle(
                color: Tcolor.primary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\N${basePrice.toStringAsFixed(2)}",
              style: TextStyle(
                color: Tcolor.primaryText,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "/ per portion",
              style: TextStyle(
                color: Tcolor.primaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      text,
      style: TextStyle(
        color: Tcolor.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _buildDescription() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      "Tandoori Chicken Pizza is a fusion of bold Indian flavors and classic Italian style. "
      "It features a crispy crust topped with marinated tandoori chicken, tomato sauce, melted mozzarella, and aromatic spices.",
      style: TextStyle(color: Tcolor.secondaryText, fontSize: 13, height: 1.4),
      textAlign: TextAlign.justify,
    ),
  );

  Widget _buildDivider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Divider(color: Tcolor.secondaryText.withOpacity(0.4), height: 1),
  );

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Tcolor.textbox,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: onChanged,
          hint: Text(label, style: TextStyle(color: Tcolor.secondaryText)),
          isExpanded: true,
        ),
      ),
    ),
  );

  Widget _buildPortionCounter() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      children: [
        Text(
          "Number of Portions",
          style: TextStyle(
            color: Tcolor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        _counterButton("-", () {
          if (quantity > 1) setState(() => quantity--);
        }),
        const SizedBox(width: 12),
        Text(
          "$quantity",
          style: TextStyle(
            color: Tcolor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        _counterButton("+", () => setState(() => quantity++)),
      ],
    ),
  );

  Widget _counterButton(String symbol, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: symbol == "+" ? Tcolor.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Tcolor.primary),
      ),
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            color: symbol == "+" ? Colors.white : Tcolor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Price",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                "\N${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Tcolor.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text("Add to Cart"),
        ),
      ],
    ),
  );

  void _addToCart() {
    if (selectedSize == null || selectedIngredient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please customize your order")),
      );
      return;
    }

    final item = CartItem(
      id: 'pizza_tandoori', // unique product id
      title: 'Tandoori Chicken Pizza',
      unitPrice: unitPrice,
      quantity: quantity,
      size: selectedSize,
      ingredient: selectedIngredient,
      image: 'assets/images/pizza.jpg',
    );

    ref.read(cartProvider.notifier).addOrIncrement(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Added $quantity × ${selectedSize!} Pizza (${selectedIngredient!})",
        ),
      ),
    );

    // Optional: jump straight to cart
    // context.push('/cart');
  }
}
