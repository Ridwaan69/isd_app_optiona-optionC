// lib/widgets/app_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart_provider.dart';

class AppBottomBar extends StatelessWidget {
  /// 0: Home, 1: Profile, 2: Cart
  final int activeIndex;

  /// Optional styling so this widget has no hard dependency on your color consts
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  AppBottomBar({
    super.key,
    required this.activeIndex,
    this.backgroundColor = const Color(0xFFBDEDF0), // kAqua
    this.activeColor = const Color(0xFF146C72),      // kDeepBlue
    Color? inactiveColor,
  }) : inactiveColor = inactiveColor ?? const Color(0xFF146C72).withOpacity(0.6);
  void _go(BuildContext context, int i) {
    if (i == activeIndex) return;
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');      // Home
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
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
      backgroundColor: backgroundColor,
      selectedItemColor: activeColor,
      unselectedItemColor: inactiveColor,
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
