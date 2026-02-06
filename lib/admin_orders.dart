import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  final List<String> _statuses = ['pending', 'completed'];

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchAllOrders();
  }

  Future<List<Map<String, dynamic>>> _fetchAllOrders() async {
    final response = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> _confirmStatusChange(
    String orderNumber,
    String newStatus,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: kDeepBlue, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    'Confirm Status Change',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kDeepBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Are you sure you want to change Order #$orderNumber status to ${newStatus.toUpperCase()}?',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: kDeepBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: kDeepBlue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Confirm Button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDeepBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<void> _updateStatus(String orderId, String status) async {
    if (orderId.isEmpty) return;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await supabase
          .from('orders')
          .update({'status': status.toLowerCase()})
          .eq('id', orderId);

      Navigator.of(context).pop(); // remove loading
      setState(() {
        _ordersFuture = _fetchAllOrders();
      });
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'All Orders (Admin)',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = (order['order_items'] as List<dynamic>?) ?? [];

              final String currentStatus =
                  _statuses.contains(order['status']?.toString())
                  ? order['status'].toString()
                  : 'pending';
              final double total = (order['total'] ?? 0).toDouble();

              final Color cardColor = currentStatus == 'completed'
                  ? Colors.green[50]!
                  : Colors.white;

              return Card(
                color: cardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    'Order #${order['order_number'] ?? 'N/A'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kDeepBlue,
                    ),
                  ),
                  subtitle: Text(
                    'Total: Rs ${total.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Status:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kDeepBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: currentStatus,
                            underline: Container(),
                            style: const TextStyle(
                              color: kDeepBlue,
                              fontWeight: FontWeight.w600,
                            ),
                            items: _statuses.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              if (value != null) {
                                final orderId = order['id']?.toString() ?? '';
                                if (orderId.isEmpty) return;

                                final confirmed = await _confirmStatusChange(
                                  order['order_number']?.toString() ?? 'N/A',
                                  value,
                                );
                                if (confirmed) {
                                  _updateStatus(orderId, value);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    ...items.map((item) {
                      final double price = (item['price'] ?? 0).toDouble();
                      final String options =
                          item['selected_options']?.toString() ?? '';

                      return ListTile(
                        title: Text(
                          item['name'] ?? 'Unnamed Item',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        subtitle: Text(
                          'Qty: ${item['quantity'] ?? 0}' +
                              (options.isNotEmpty ? ' | $options' : ''),
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Text(
                          'Rs ${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
