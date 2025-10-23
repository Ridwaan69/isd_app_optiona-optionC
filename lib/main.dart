import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import login and signup screens
import 'login.dart'; // provides LandingScreen, CustomerLoginScreen, AdminLoginScreen
import 'signup_screen.dart'; // provides SignUpScreen
import 'homepage.dart';// provides HomePageScreen
import 'menu.dart';// provides MenuScreen
import 'profile_settings.dart';// provides MenuScreen

void main() => runApp(const App());

/* ---------------- Theme bits used by the rest of the app ---------------- */
const _aqua = Color(0xFFBDEDF0);
const _deepBlue = Color(0xFF146C72);

/* ---------------- Models ---------------- */
class MenuItem {
  final String id, name, imageUrl, category;
  final double price;
  final List<String> options;
  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.options = const [],
  });
}

class CartLine {
  final MenuItem item;
  final int qty;
  final List<String> selected;
  const CartLine({required this.item, this.qty = 1, this.selected = const []});

  CartLine copyWith({MenuItem? item, int? qty, List<String>? selected}) =>
      CartLine(item: item ?? this.item, qty: qty ?? this.qty, selected: selected ?? this.selected);

  double get lineTotal => item.price * qty;
}

/* ---------------- Demo data ---------------- */
const demoMenu = <MenuItem>[
  MenuItem(
    id: '1',
    name: 'Grilled Fish',
    price: 250,
    imageUrl: 'https://picsum.photos/seed/fish/400/300',
    category: 'Mains',
    options: ['No chili', 'Extra sauce', 'Lemon'],
  ),
  MenuItem(
    id: '2',
    name: 'Seafood Platter',
    price: 480,
    imageUrl: 'https://picsum.photos/seed/platter/400/300',
    category: 'Mains',
    options: ['Add prawns', 'No garlic'],
  ),
  MenuItem(
    id: '3',
    name: 'Lobster Roll',
    price: 320,
    imageUrl: 'https://picsum.photos/seed/lobster/400/300',
    category: 'Snacks',
    options: ['Extra butter', 'No mayo'],
  ),
];

/* ---------------- State ---------------- */
class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];
  List<CartLine> get lines => List.unmodifiable(_lines);

  void add(MenuItem item, {int qty = 1, List<String> selected = const []}) {
    final idx = _lines.indexWhere((l) =>
    l.item.id == item.id &&
        l.selected.length == selected.length &&
        _sameOptions(l.selected, selected));
    if (idx >= 0) {
      final cur = _lines[idx];
      _lines[idx] = cur.copyWith(qty: cur.qty + qty);
    } else {
      _lines.add(CartLine(item: item, qty: qty, selected: selected));
    }
    notifyListeners();
  }

  void updateQty(int index, int qty) {
    if (qty <= 0) {
      _lines.removeAt(index);
    } else {
      _lines[index] = _lines[index].copyWith(qty: qty);
    }
    notifyListeners();
  }

  double get total => _lines.fold(0, (s, l) => s + l.lineTotal);
  void clear() {
    _lines.clear();
    notifyListeners();
  }

  static bool _sameOptions(List<String> a, List<String> b) {
    final sa = [...a]..sort();
    final sb = [...b]..sort();
    if (sa.length != sb.length) return false;
    for (int i = 0; i < sa.length; i++) {
      if (sa[i] != sb[i]) return false;
    }
    return true;
  }
}

/* ---------------- App ---------------- */
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'SeaFeast',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: _deepBlue,
          scaffoldBackgroundColor: _aqua,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: _deepBlue,
            displayColor: _deepBlue,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: _deepBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const LandingScreen(), // from login.dart
        routes: {
          '/login/customer': (_) => const CustomerLoginScreen(),
          '/login/admin': (_) => const AdminLoginScreen(),
          '/signup': (_) => const SignUpScreen(), // 👈 Sign Up screen added
          '/home': (_) => const HomePage(),     // <-- must exist
          '/home/menu': (_) => const MenuScreen(),     // <-- must exist
          // ✅ Register the route your Home is using
          '/menu': (_) => const MenuScreen(),
          '/profile': (_) => const ProfileSettingsScreen(),
        },
      ),
    );
  }
}

/* ---------------- Rest of your app (unchanged) ---------------- */

class MenuScreen1 extends StatelessWidget {
  const MenuScreen1({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _aqua,
        title: const Text('Browse Menu'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartScreen())),
            icon: const Icon(Icons.shopping_cart, color: _deepBlue),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .76,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: demoMenu.length,
        itemBuilder: (_, i) {
          final m = demoMenu[i];
          return Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailsScreen(item: m))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.network(m.imageUrl, fit: BoxFit.cover)),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('Rs ${m.price.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          FilledButton.tonal(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        DetailsScreen(item: m))),
                            child: const Text('Customize'),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final MenuItem item;
  const DetailsScreen({super.key, required this.item});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Set<String> picked = {};
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(backgroundColor: _aqua, title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(item.imageUrl, fit: BoxFit.cover)),
          const SizedBox(height: 12),
          Text('Rs ${item.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          if (item.options.isNotEmpty) const Text('Options'),
          Wrap(
            spacing: 8,
            children: item.options
                .map((o) => FilterChip(
              label: Text(o),
              selected: picked.contains(o),
              onSelected: (sel) => setState(() {
                sel ? picked.add(o) : picked.remove(o);
              }),
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                  onPressed: () =>
                      setState(() {
                        if (qty > 1) qty--;
                      }),
                  icon: const Icon(Icons.remove_circle_outline)),
              Text('$qty', style: const TextStyle(fontSize: 18)),
              IconButton(
                  onPressed: () => setState(() {
                    qty++;
                  }),
                  icon: const Icon(Icons.add_circle_outline)),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  context
                      .read<CartProvider>()
                      .add(item, qty: qty, selected: picked.toList());
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')));
                },
                child: const Text('Add to cart'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CartScreen())),
        label: const Text('Go to Cart'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(backgroundColor: _aqua, title: const Text('Your Cart')),
      body: cart.lines.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cart.lines.length,
        itemBuilder: (_, i) {
          final l = cart.lines[i];
          return Card(
            child: ListTile(
              leading:
              CircleAvatar(backgroundImage: NetworkImage(l.item.imageUrl)),
              title: Text(l.item.name),
              subtitle: Text([
                if (l.selected.isNotEmpty)
                  'Options: ${l.selected.join(", ")}',
                'Rs ${l.item.price.toStringAsFixed(2)} × ${l.qty}',
              ].join('\n')),
              trailing: SizedBox(
                width: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () =>
                            cart.updateQty(i, l.qty - 1),
                        icon: const Icon(Icons.remove)),
                    Text('${l.qty}'),
                    IconButton(
                        onPressed: () =>
                            cart.updateQty(i, l.qty + 1),
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Text('Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text('Rs ${cart.total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
          ]),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: cart.lines.isEmpty
                ? null
                : () async {
              final ok = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  title: const Text('Payment'),
                  content:
                  const Text('Simulate payment success?'),
                  actions: [
                    TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () =>
                            Navigator.pop(context, true),
                        child: const Text('Pay (Simulated)')),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                cart.clear();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SuccessScreen()));
              }
            },
            child: const Text('Proceed to Pay'),
          ),
        ]),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle, size: 88, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Order placed & paid (simulated)!',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen1()),
                    (_) => false,
              );
            },
            child: const Text('Back to Menu'),
          ),
        ]),
      ),
    );
  }
}
