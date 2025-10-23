import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: const Text('Your Cart'),
      ),
      bottomNavigationBar: const _AppBottomBar(activeIndex: 2),
      body: const _CartBody(),
    );
  }
}

class _CartBody extends StatelessWidget {
  const _CartBody();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final lines = cart.lines;

    if (lines.isEmpty) return const _EmptyCart();

    final currency = 'Rs ';
    final subtotal = cart.subtotal;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            itemCount: lines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final line = lines[i];
              final MenuItem item = line.item;
              final int qty = line.qty;
              final double lineTotal = item.price * qty;

              return Dismissible(
                key: ValueKey('${item.id}-$i'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red.shade400,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => context.read<CartProvider>().removeAt(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _Thumb(imageUrl: item.imageUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                            if (line.selected.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                line.selected.join(' • '),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              '$currency${item.price.toStringAsFixed(2)} each',
                              style: const TextStyle(
                                  color: Color(0xFF34495e), fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QtyStepper(
                        qty: qty,
                        onDec: () {
                          final newQty = qty - 1;
                          if (newQty <= 0) {
                            context.read<CartProvider>().removeAt(i);
                          } else {
                            context.read<CartProvider>().updateQty(i, newQty);
                          }
                        },
                        onInc: () => context.read<CartProvider>().updateQty(i, qty + 1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$currency${lineTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Color(0xFF34495e)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Summary
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Subtotal',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(
                    '$currency${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF34495e)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kDeepBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout coming soon')),
                    );
                  },
                  child: const Text('Proceed to checkout'),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => context.read<CartProvider>().clear(),
                child: const Text('Clear cart'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket_outlined,
                size: 64, color: Colors.black.withOpacity(0.35)),
            const SizedBox(height: 12),
            const Text(
              'Your basket is empty',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text('Browse the menu and add some items.',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kDeepBlue),
              onPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
              child: const Text('Browse menu'),
            )
          ],
        ),
      ),
    );
  }
}

/* ---------- Small UI helpers ---------- */

class _Thumb extends StatelessWidget {
  final String imageUrl;
  const _Thumb({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isHttp = imageUrl.startsWith('http');
    final radius = BorderRadius.circular(8);

    Widget img;
    if (isHttp) {
      img = Image.network(imageUrl, fit: BoxFit.cover, width: 62, height: 62);
    } else {
      img = Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: 62,
        height: 62,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.image_not_supported_outlined),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: 62,
        height: 62,
        color: const Color(0xFFEFF4FA),
        child: img,
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onDec;
  final VoidCallback onInc;
  const _QtyStepper({required this.qty, required this.onDec, required this.onInc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stepBtn(icon: Icons.remove_circle_outline, onTap: onDec),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('$qty', style: const TextStyle(fontSize: 16)),
        ),
        _stepBtn(icon: Icons.add_circle_outline, onTap: onInc),
      ],
    );
  }

  Widget _stepBtn({required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      radius: 18,
      onTap: onTap,
      child: Icon(icon, size: 22, color: kDeepBlue),
    );
  }
}

/* ---------- Bottom bar (with live badge) ---------- */

class _AppBottomBar extends StatelessWidget {
  final int activeIndex; // 0: home, 1: profile, 2: cart
  const _AppBottomBar({required this.activeIndex});

  void _go(BuildContext context, int i) {
    if (i == activeIndex) return;
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
      // already here
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
                    constraints:
                    const BoxConstraints(minWidth: 16, minHeight: 16),
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
