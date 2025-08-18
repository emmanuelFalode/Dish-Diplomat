import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodapp/widgets/color_extension.dart';
import 'package:go_router/go_router.dart';

class ItemsDetails extends StatefulWidget {
  const ItemsDetails({super.key});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  double price = 15;
  String? selectedSize; // Initially null to show hint
  String? selectedIngredient; // Initially null to show hint
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30),
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
                      items: ["Small", "Big"],
                      onChanged: (val) => setState(() => selectedSize = val),
                    ),
                    const SizedBox(height: 15),
                    _buildDropdown(
                      label: "-Select the Ingredients-",
                      value: selectedIngredient,
                      items: ["Cheese", "Onion", "Tomato", "Chicken"],
                      onChanged:
                          (val) => setState(() => selectedIngredient = val),
                    ),
                    const SizedBox(height: 20),
                    _buildPortionCounter(),
                    const SizedBox(height: 40),
                    _buildAddCart(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String text) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      text,
      style: TextStyle(
        color: Tcolor.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
  Widget _buildRatingAndPrice() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
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
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Tcolor.primary),
                onRatingUpdate: (rating) {},
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
              "\$${price.toStringAsFixed(2)}",
              style: TextStyle(
                color: Tcolor.primaryText,
                fontSize: 31,
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
      "Tandoori Chicken Pizza is a mouthwatering fusion of bold Indian flavors and classic Italian style. It features a crispy, golden-baked crust topped with tender, marinated tandoori chicken, rich tomato sauce, melted mozzarella cheese, and a blend of aromatic spices.",
      style: TextStyle(color: Tcolor.secondaryText, fontSize: 12, height: 1.4),
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
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              items.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(color: Tcolor.primaryText, fontSize: 14),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          hint: Text(
            label,
            style: TextStyle(color: Tcolor.secondaryText, fontSize: 14),
          ),
          isExpanded: true,
        ),
      ),
    ),
  );

  Widget _buildPortionCounter() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      children: [
        Text(
          "Number of Portions",
          style: TextStyle(
            color: Tcolor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        _counterButton("-", () {
          if (quantity > 1) {
            setState(() => quantity--);
          }
        }),
        SizedBox(width: 10),
        Text(
          "$quantity",
          style: TextStyle(
            color: Tcolor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10),
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
            fontSize: 18,
          ),
        ),
      ),
    ),
  );

  Widget _buildAddCart() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Price",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "\$30",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.shopping_cart, size: 16, color: Tcolor.primary),
            ],
          ),
        ),
      ],
    ),
  );
}
