import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/providers/me_provider.dart';
import 'package:foodapp/screens/bottombars/widget/catergory_cell.dart';
import 'package:foodapp/widgets/color_extension.dart';
import 'package:foodapp/screens/bottombars/widget/most_popular_cell.dart';
import 'package:foodapp/screens/bottombars/widget/pop_row.dart';
import 'package:foodapp/screens/bottombars/widget/recent_items.dart';
import 'package:foodapp/screens/bottombars/widget/view_all_title_rows.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  TextEditingController txtsearch = TextEditingController();

  List catArr = [
    {"image": "assets/images/food1.jpg", "name": "Offers"},
    {"image": "assets/images/food5.jpg", "name": "Sri Lankan"},
    {"image": "assets/images/food3.jpg", "name": "Italian"},
    {"image": "assets/images/food4.jpg", "name": "Indian"},
  ];

  List popArr = [
    {
      "image": "assets/images/food7.jpg",
      "name": "Minutes by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
    {
      "image": "assets/images/food8.jpg",
      "name": "Cafe de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
    {
      "image": "assets/images/food3.jpg",
      "name": "Bakes by Tella",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
    {
      "image": "assets/images/food4.jpg",
      "name": "Indian",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/images/food7.jpg",
      "name": "Minutes by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
    {
      "image": "assets/images/food8.jpg",
      "name": "Cafe de Noir",
      "rate": "4.7",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
  ];

  List recentArr = [
    {
      "image": "assets/images/pizza.jpg",
      "name": "Mulberry Pizza by John",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
    {
      "image": "assets/images/food6.jpg",
      "name": "Barita",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
    {
      "image": "assets/images/food3.jpg",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafe",
      "food_type": "Western Food",
    },
  ];

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final meAsync = ref.watch(meProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: meAsync.when(
                data: (me) {
                  final first = (me['first_name'] ?? '').toString().trim();

                  final name = [first].where((s) => s.isNotEmpty).join(' ');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_greeting()} ${name.isEmpty ? 'Friend' : name},',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push("/cart"),
                        icon: const Icon(Icons.shopping_cart, size: 30),
                      ),
                    ],
                  );
                },
                loading:
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Good day …',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Icon(Icons.shopping_cart, size: 30),
                      ],
                    ),
                error:
                    (e, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Good day,',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.push("/cart"),
                          icon: const Icon(Icons.shopping_cart, size: 30),
                        ),
                      ],
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivering to",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "Current Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: txtsearch,
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

            const SizedBox(height: 20),

            // BODY SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 148,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: catArr.length,
                        itemBuilder: (context, index) {
                          var cObj = catArr[index] as Map? ?? {};
                          return CatergoryCell(cObj: cObj, onTap: () {});
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ViewAllTitleRows(
                        title: "Popular Restaurants",
                        onView: () {},
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: popArr.length,
                      itemBuilder: (context, index) {
                        var pObj = popArr[index] as Map? ?? {};
                        return PopRow(pObj: pObj, onTap: () {});
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ViewAllTitleRows(
                        title: "Most Popular",
                        onView: () {},
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: mostPopArr.length,
                        itemBuilder: (context, index) {
                          var mObj = mostPopArr[index] as Map? ?? {};
                          return MostPopularCell(cObj: mObj, onTap: () {});
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ViewAllTitleRows(
                        title: "Recent Items",
                        onView: () {},
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: recentArr.length,
                      itemBuilder: (context, index) {
                        var rObj = recentArr[index] as Map? ?? {};
                        return RecentItems(rObj: rObj, onTap: () {});
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
