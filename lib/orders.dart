import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  final List<String> _statuses = ['pending', 'completed'];

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('orders')
        .select('*, order_items(*)') // fetch items too
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: const Text('My Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }

          final orders = snapshot.data!;
          orders.sort((a, b) {
            final statusA = (a['status'] ?? 'pending').toString();
            final statusB = (b['status'] ?? 'pending').toString();

            // pending first, completed last
            if (statusA == statusB) return 0;
            if (statusA == 'pending') return -1;
            return 1;
          });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = (order['order_items'] as List<dynamic>? ?? []);
              final String status = order['status']?.toString() ?? 'pending';

              // ✅ Card color based on status
              final Color cardColor = status.toLowerCase() == 'completed'
                  ? Colors.green[50]!
                  : Colors.white;

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    'Order #${order['order_number'] ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Total: Rs ${(order['total'] ?? 0).toDouble().toStringAsFixed(2)} • Status: ${status.toUpperCase()}',
                  ),
                  children: [
                    const Divider(),
                    ...items.map((item) {
                      final double price = (item['price'] ?? 0).toDouble();
                      final String options =
                          item['selected_options']?.toString() ?? '';
                      return ListTile(
                        title: Text(item['name'] ?? 'Unnamed Item'),
                        subtitle: Text(
                          'Qty: ${item['quantity'] ?? 0}' +
                              (options.isNotEmpty ? ' | $options' : ''),
                        ),
                        trailing: Text(
                          'Rs ${price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
