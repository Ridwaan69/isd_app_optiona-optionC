import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

/* ---------- Data models for the menu UI ---------- */

class ChoiceGroup {
  final String title;
  final bool singleSelect; // false => checkboxes, true => radios
  final List<String> options;

  const ChoiceGroup({
    required this.title,
    required this.options,
    this.singleSelect = false,
  });
}

class MenuCardData {
  final String id;
  final String name;
  final double price;
  final String image; // asset path or http url
  final String description;
  final String allergens;
  final List<ChoiceGroup> choices;

  const MenuCardData({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.allergens,
    this.choices = const [],
  });
}

class MenuSectionData {
  final String title;
  final List<MenuCardData> items;
  const MenuSectionData(this.title, this.items);
}

/* ---------- Content ---------- */

final _sections = <MenuSectionData>[
  // Starters
  MenuSectionData('Starters', [
    const MenuCardData(
      id: 'starter_calamari',
      name: 'Fried Calamari',
      price: 774.80,
      image: 'lib/images/Fried-Calamari.jpg',
      description: 'Crispy calamari with tartar sauce.',
      allergens: 'Shellfish, Gluten',
      choices: [
        ChoiceGroup(title: 'Customizations', options: [
          'Extra Tartar Sauce',
          'Extra Lemon',
          'Marinara Sauce'
        ]),
        ChoiceGroup(
          title: 'Spice Level',
          singleSelect: true,
          options: ['Mild', 'Medium', 'Hot'],
        ),
      ],
    ),
    const MenuCardData(
      id: 'starter_shrimp_cocktail',
      name: 'Shrimp Cocktail',
      price: 683.30,
      image: 'lib/images/Shrimp-Cocktail.jpeg',
      description: 'Chilled jumbo shrimp with cocktail sauce.',
      allergens: 'Shellfish',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Extra Cocktail Sauce', 'Extra Lemon', 'Avocado'],
        ),
      ],
    ),
  ]),
  // Main Courses
  MenuSectionData('Main Courses', [
    const MenuCardData(
      id: 'main_lobster',
      name: 'Grilled Lobster',
      price: 1505.70,
      image: 'lib/images/Grilled Lobster.jpg',
      description: 'Fresh lobster with garlic butter and lemon.',
      allergens: 'Shellfish',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Extra Garlic Butter', 'Extra Lemon', 'Chili Flakes'],
        ),
        ChoiceGroup(
          title: 'Spice Level',
          singleSelect: true,
          options: ['Mild', 'Medium', 'Hot'],
        ),
      ],
    ),
    const MenuCardData(
      id: 'main_salmon',
      name: 'Grilled Salmon',
      price: 1140.90,
      image: 'lib/images/Grilled-Salmon.jpg',
      description: 'Atlantic salmon with herbs.',
      allergens: 'Fish',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Lemon Butter Sauce', 'Dill Sauce', 'Extra Herbs'],
        ),
        ChoiceGroup(
          title: 'Cooking Preference',
          singleSelect: true,
          options: ['Medium', 'Medium Well', 'Well Done'],
        ),
      ],
    ),
  ]),
  // Drinks
  MenuSectionData('Drinks', [
    const MenuCardData(
      id: 'drink_lemonade',
      name: 'Fresh Lemonade',
      price: 227.00,
      image: 'lib/images/Fresh-Lemonade.jpeg',
      description: 'Homemade lemonade with mint and lime.',
      allergens: 'None',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Extra Mint', 'Strawberry Puree', 'Raspberry Flavor'],
        ),
        ChoiceGroup(
          title: 'Size',
          singleSelect: true,
          options: ['Regular', 'Large'],
        ),
      ],
    ),
    const MenuCardData(
      id: 'drink_iced_tea',
      name: 'Iced Tea',
      price: 181.51,
      image: 'lib/images/Iced-Tea.jpeg',
      description: 'Freshly brewed iced tea with lemon.',
      allergens: 'None',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Extra Lemon', 'Mint Leaves', 'Peach Flavor'],
        ),
        ChoiceGroup(
          title: 'Sweetness',
          singleSelect: true,
          options: ['Unsweetened', 'Lightly Sweet', 'Sweet'],
        ),
      ],
    ),
  ]),
  // Desserts
  MenuSectionData('Desserts', [
    const MenuCardData(
      id: 'dessert_key_lime',
      name: 'Key Lime Pie',
      price: 363.47,
      image: 'lib/images/Key-Lime-Pie.jpg',
      description: 'Tangy key lime pie with graham crust.',
      allergens: 'Dairy, Gluten',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Whipped Cream', 'Lime Zest', 'Extra Crust'],
        ),
      ],
    ),
    const MenuCardData(
      id: 'dessert_lava',
      name: 'Chocolate Lava Cake',
      price: 408.96,
      image: 'lib/images/Chocolate-Lava-Cake.jpeg',
      description: 'Warm cake with molten center.',
      allergens: 'Dairy, Gluten, Eggs',
      choices: [
        ChoiceGroup(
          title: 'Customizations',
          options: ['Extra Ice Cream', 'Chocolate Sauce', 'Fresh Berries'],
        ),
      ],
    ),
  ]),
];

/* ---------- Helpers ---------- */

double _adaptiveCardHeight(BuildContext context) {
  final h = MediaQuery.of(context).size.height;
  final proposed = h * 0.95; // more space on tiny phones
  const minH = 600.0;
  const maxH = 780.0;
  return proposed.clamp(minH, maxH);
}

MenuSectionData _byTitle(String title) =>
    _sections.firstWhere((s) => s.title == title);

/* ---------- Menu Screen with 4 tabs ---------- */

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kAqua,
        appBar: AppBar(
          backgroundColor: kAqua,
          centerTitle: true,
          title: const Text('SEAFEAST Menu'),
          actions: [
            // AppBar cart icon with live badge
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/cart'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.shopping_cart, color: kDeepBlue),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Consumer<CartProvider>(
                        builder: (_, cart, __) => cart.totalItems > 0
                            ? Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.totalItems}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        bottomNavigationBar: const _AppBottomBar(activeIndex: 0),

        body: Column(
          children: [
            // fixed-width 4 tabs (no horizontal scroll)
            Material(
              color: kAqua,
              child: TabBar(
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                labelColor: kDeepBlue,
                unselectedLabelColor: const Color(0xFF2B5B66),
                indicatorColor: kDeepBlue,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Starters'),
                  Tab(text: 'Main Courses'),
                  Tab(text: 'Drinks'),
                  Tab(text: 'Desserts'),
                ],
              ),
            ),

            const Expanded(
              child: TabBarView(
                children: [
                  _SectionView(sectionTitle: 'Starters'),
                  _SectionView(sectionTitle: 'Main Courses'),
                  _SectionView(sectionTitle: 'Drinks'),
                  _SectionView(sectionTitle: 'Desserts'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- One section per tab ---------- */

class _SectionView extends StatelessWidget {
  final String sectionTitle;
  const _SectionView({required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    final section = _byTitle(sectionTitle);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: kDeepBlue, width: 2)),
          ),
          child: Text(
            section.title,
            style: const TextStyle(
              color: kDeepBlue,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 14),

        LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final cross = w >= 980 ? 3 : (w >= 660 ? 2 : 1);

            final gridDelegate = cross == 1
                ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: _adaptiveCardHeight(context),
            )
                : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cross,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: (cross == 3 ? 0.70 : 0.78),
            );

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: gridDelegate,
              itemCount: section.items.length,
              itemBuilder: (_, i) => _MenuCard(section.items[i]),
            );
          },
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

/* ---------- Bottom bar (reused) ---------- */

class _AppBottomBar extends StatelessWidget {
  final int activeIndex; // 0: home, 1: profile, 2: cart
  const _AppBottomBar({required this.activeIndex});

  void _go(BuildContext context, int i) {
    if (i == activeIndex) return;
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/'); // Home (if you have one)
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile'); // if you add it
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalItems;

    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: (i) => _go(context, i),
      backgroundColor: kAqua,
      selectedItemColor: kDeepBlue,
      unselectedItemColor: kDeepBlue.withOpacity(0.6),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ''),
        BottomNavigationBarItem(
          label: '',
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_basket_rounded),
              if (cartCount > 0)
                Positioned(
                  right: -6,
                  top: -3,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$cartCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ---------- Menu card ---------- */

class _MenuCard extends StatefulWidget {
  final MenuCardData data;
  const _MenuCard(this.data);

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  int qty = 1;
  final Map<String, Set<String>> multi = {};
  final Map<String, String> single = {};

  @override
  void initState() {
    super.initState();
    for (final g in widget.data.choices) {
      if (g.singleSelect) {
        single[g.title] = g.options.first;
      } else {
        multi[g.title] = <String>{};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MenuImage(pathOrUrl: d.image),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    d.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                Text(
                  'Rs ${d.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF34495e),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(d.description, style: const TextStyle(color: Colors.black87, fontSize: 13.5)),
            const SizedBox(height: 6),
            Text('Allergens: ${d.allergens}', style: const TextStyle(color: Color(0xFFE67E22), fontSize: 12.5)),
            const SizedBox(height: 8),

            for (final g in d.choices) ...[
              Text(g.title, style: const TextStyle(color: kDeepBlue, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: g.singleSelect
                    ? g.options.map((o) {
                  final selected = single[g.title] == o;
                  return ChoiceChip(
                    label: Text(o),
                    selected: selected,
                    onSelected: (_) => setState(() => single[g.title] = o),
                  );
                }).toList()
                    : g.options.map((o) {
                  final set = multi[g.title]!;
                  final selected = set.contains(o);
                  return FilterChip(
                    label: Text(o),
                    selected: selected,
                    onSelected: (sel) => setState(() {
                      sel ? set.add(o) : set.remove(o);
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],

            Row(
              children: [
                const Text('Quantity:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => setState(() {
                    if (qty > 1) qty--;
                  }),
                ),
                Text('$qty', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => qty++),
                ),
                const Spacer(),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final selected = <String>[
                    for (final e in multi.entries) ...e.value,
                    for (final e in single.entries) '${e.key}: ${e.value}',
                  ];

                  final addedQty = qty; // capture before reset

                  context.read<CartProvider>().add(
                    MenuItem(
                      id: d.id,
                      name: d.name,
                      price: d.price,
                      imageUrl: d.image,
                      category: '',
                      options: const [],
                    ),
                    qty: addedQty,
                    selected: selected,
                  );

                  setState(() => qty = 1); // reset after adding

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${d.name} ×$addedQty added to cart')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: kDeepBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  final String pathOrUrl;
  const _MenuImage({required this.pathOrUrl});

  @override
  Widget build(BuildContext context) {
    final isHttp = pathOrUrl.startsWith('http');

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFB9D6F0),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: isHttp
            ? Image.network(
          pathOrUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        )
            : Image.asset(
          pathOrUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => const Text('Image not found'),
        ),
      ),
    );
  }
}
