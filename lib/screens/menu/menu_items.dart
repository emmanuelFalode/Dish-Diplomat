import 'package:flutter/material.dart';
import 'package:foodapp/screens/menu/widget/items_details.dart';
import 'package:foodapp/screens/menu/widget/menu_item_rows.dart';

class MenuItems extends StatefulWidget {
  final Map? mobj;
  const MenuItems({super.key, this.mobj});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> with TickerProviderStateMixin {
  TextEditingController txtsearch = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  List<Map<String, String>> popArr = [
    {
      "image": "assets/images/desert2.jpg",
      "name": "Cake",
      "rate": "4.7",
      "rating": "210",
      "type": "Snackbar",
      "food_type": "Sweet Treat",
    },
    {
      "image": "assets/images/desert.jpg",
      "name": "Sugar Wraps",
      "rate": "4.6",
      "rating": "189",
      "type": "Snackbar",
      "food_type": "Pastries",
    },
    {
      "image": "assets/images/food3.jpg",
      "name": "Sugar Craft",
      "rate": "4.8",
      "rating": "234",
      "type": "Bakery",
      "food_type": "Desserts",
    },
    {
      "image": "assets/images/food4.jpg",
      "name": "El Mexicano",
      "rate": "4.5",
      "rating": "198",
      "type": "Restaurant",
      "food_type": "Mexican",
    },
  ];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredList =
        popArr
            .where(
              (item) => item['name']!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.mobj?["name"]?.toString() ?? "Menu",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart, size: 28),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: txtsearch,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search Food",
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CONTENT LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var mObj = filteredList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MenuItemRows(
                      mObj: mObj,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                            pageBuilder: (_, __, ___) => ItemsDetails(),
                            transitionsBuilder: (_, animation, __, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              final tween = Tween(begin: begin, end: end);
                              final curvedAnimation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              );

                              return SlideTransition(
                                position: tween.animate(curvedAnimation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
