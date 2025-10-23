import 'package:flutter/foundation.dart';

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> options;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.options,
  });
}

class CartLine {
  final MenuItem item;
  int qty;
  final List<String> selected; // e.g. ["Spice Level: Medium", "Extra Lemon"]

  CartLine({required this.item, this.qty = 1, this.selected = const []});
}

class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  int get totalItems => _lines.fold(0, (s, l) => s + l.qty);

  double get subtotal =>
      _lines.fold(0.0, (s, l) => s + (l.item.price * l.qty));

  void add(MenuItem item, {int qty = 1, List<String> selected = const []}) {
    final idx = _lines.indexWhere(
          (l) => l.item.id == item.id && _sameOptions(l.selected, selected),
    );
    if (idx >= 0) {
      _lines[idx].qty += qty;
    } else {
      _lines.add(CartLine(item: item, qty: qty, selected: selected));
    }
    notifyListeners();
  }

  void updateQty(int index, int newQty) {
    if (index < 0 || index >= _lines.length) return;
    _lines[index].qty = newQty.clamp(1, 999);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _lines.length) return;
    _lines.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }

  bool _sameOptions(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sa = a.toList()..sort();
    final sb = b.toList()..sort();
    for (var i = 0; i < sa.length; i++) {
      if (sa[i] != sb[i]) return false;
    }
    return true;
  }
}
