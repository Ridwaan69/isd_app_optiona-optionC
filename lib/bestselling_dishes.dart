import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'app_localizations.dart';

/*
|--------------------------------------------------------------------------
| Best Selling Dishes Widget
|--------------------------------------------------------------------------
| - Hardcoded list (safe for demo / MVP)
| - Independent from menu sections
| - Easy to replace later with Supabase / analytics
|--------------------------------------------------------------------------
*/

const kBestAqua = Color(0xFFBDEDF0);
const kBestDeepBlue = Color(0xFF146C72);

class BestSellingDish {
  final String id;
  final String name;
  final double price;
  final String image;

  const BestSellingDish({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

/* ---------- Hardcoded Best Sellers ---------- */
/* Replace later with backend-driven logic */
final List<BestSellingDish> bestSellingDishes = [
  BestSellingDish(
    id: 'main_lobster',
    name: 'Grilled Lobster',
    price: 1505.70,
    image: 'lib/images/Grilled Lobster.jpg',
  ),
  BestSellingDish(
    id: 'main_salmon',
    name: 'Grilled Salmon',
    price: 1140.90,
    image: 'lib/images/Grilled-Salmon.jpg',
  ),
  BestSellingDish(
    id: 'dessert_lava',
    name: 'Chocolate Lava Cake',
    price: 408.96,
    image: 'lib/images/Chocolate-Lava-Cake.jpeg',
  ),
];

class BestSellingDishesSection extends StatelessWidget {
  const BestSellingDishesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* ---------- Section Title ---------- */
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '🔥 ${loc.bestSellingDishes}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kBestDeepBlue,
            ),
          ),
        ),

        /* ---------- Horizontal List ---------- */
        SizedBox(
          height: 230,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: bestSellingDishes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final dish = bestSellingDishes[index];

              return SizedBox(
                width: 180,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /* ---------- Image ---------- */
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              dish.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Text('Image not found')),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        /* ---------- Name ---------- */
                        Text(
                          dish.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),

                        /* ---------- Price ---------- */
                        Text(
                          'Rs ${dish.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /* ---------- Add Button ---------- */
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              context.read<CartProvider>().add(
                                MenuItem(
                                  id: dish.id,
                                  name: dish.name,
                                  price: dish.price,
                                  imageUrl: dish.image,
                                  category: '',
                                  options: const [],
                                ),
                                qty: 1,
                                selected: const [],
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${dish.name} ${loc.itemAddedToCart}',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: kBestDeepBlue,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                            ),
                            child: Text(loc.addToCart),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
