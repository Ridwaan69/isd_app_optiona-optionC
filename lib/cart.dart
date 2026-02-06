// lib/cart_updated.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'app_localizations.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);
const kGreen = Color(0xFF23A455);

const _currency = 'Rs ';
const _deliveryCharge = 50.0;
const _discount = 0.0;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: Text(loc.basket),
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
    final loc = AppLocalizations.of(context);
    final cart = context.watch<CartProvider>();
    final lines = cart.lines;

    if (lines.isEmpty) return _EmptyCart(loc: loc);

    final sub = cart.subtotal;
    final total =
        (sub + _deliveryCharge - _discount).clamp(0, double.infinity) as double;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            itemCount: lines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final l = lines[i];
              final m = l.item;
              return _ItemCard(
                name: m.name,
                price: m.price,
                imageUrl: m.imageUrl,
                qty: l.qty,
                onMinus: () {
                  final q = l.qty - 1;
                  if (q <= 0) {
                    context.read<CartProvider>().removeAt(i);
                  } else {
                    context.read<CartProvider>().updateQty(i, q);
                  }
                },
                onPlus: () =>
                    context.read<CartProvider>().updateQty(i, l.qty + 1),
              );
            },
          ),
        ),
        _SummaryPanel(
          loc: loc,
          subtotal: sub,
          delivery: _deliveryCharge,
          discount: _discount,
          total: total,
          onCheckout: () => Navigator.pushNamed(context, '/checkout'),
          onCancel: () => Navigator.pushReplacementNamed(context, '/menu'),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final int qty;
  final VoidCallback onMinus, onPlus;

  const _ItemCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final isHttp = imageUrl.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 58,
              height: 58,
              color: const Color(0xFFEFF4FA),
              child: isHttp
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported_outlined),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_currency${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: kGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          _QtyPill(qty: qty, onMinus: onMinus, onPlus: onPlus),
        ],
      ),
    );
  }
}

class _QtyPill extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus, onPlus;
  const _QtyPill({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E6EF)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          _roundBtn(icon: Icons.remove, onTap: onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$qty',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          _roundBtn(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }

  Widget _roundBtn({required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(color: kAqua, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: kDeepBlue),
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  final AppLocalizations loc;
  final double subtotal, delivery, discount, total;
  final VoidCallback onCheckout, onCancel;

  const _SummaryPanel({
    required this.loc,
    required this.subtotal,
    required this.delivery,
    required this.discount,
    required this.total,
    required this.onCheckout,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFB6E8F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                loc.subtotal,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text('$_currency${subtotal.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                loc.deliveryCharge,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text('$_currency${delivery.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                loc.discount,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text('$_currency${discount.toStringAsFixed(2)}'),
            ],
          ),
          const Divider(height: 20, thickness: 1),
          Row(
            children: [
              Text(
                loc.total,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '$_currency${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: onCheckout,
              child: Text(loc.checkout),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kDeepBlue, width: 2.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                backgroundColor: Colors.white,
                foregroundColor: kDeepBlue,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: onCancel,
              child: Text(loc.cancel),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final AppLocalizations loc;
  const _EmptyCart({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: Colors.black.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Text(
              loc.emptyBasket,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              loc.emptyBasketDesc,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kDeepBlue),
              onPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
              child: Text(loc.browseMenu),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBottomBar extends StatelessWidget {
  final int activeIndex;
  const _AppBottomBar({required this.activeIndex});

  void _go(BuildContext context, int i) {
    if (i == activeIndex) return;
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
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
      unselectedItemColor: kDeepBlue.withValues(alpha: 0.6),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: '',
        ),
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
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
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
