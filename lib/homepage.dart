// lib/homepage_updated.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // SUPABASE ADDITION
import 'app_localizations.dart';
import 'app_bottom_bar.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _tab = 0;

  // ===================== USER INFO =====================
  String firstName = '';
  String lastName = '';
  String role = '';
  final _supabase = Supabase.instance.client; // SUPABASE CLIENT

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // FETCH FIRST & LAST NAME & role
  }

  Future<void> _fetchUserName() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final profile = await _supabase
          .from('user_profiles')
          .select('first_name, last_name, role')
          .eq('id', user.id)
          .single();

      setState(() {
        firstName = profile['first_name'] ?? '';
        lastName = profile['last_name'] ?? '';
        role = profile['role'] ?? '';
      });
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: kAqua,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: kDeepBlue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'SeaFeast',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),

                  // ===================== USER NAME DISPLAY =====================
                  Text(
                    '${loc.welcome} $firstName $lastName!',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ===================== MANAGE ORDERS =====================
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: Text(loc.manageOrders),
              onTap: () {
                if (role.toLowerCase() == 'admin') {
                  Navigator.pushNamed(context, '/admin_orders');
                } else {
                  Navigator.pushNamed(context, '/orders');
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(loc.logout),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: kAqua,
        elevation: 0,
        centerTitle: true,
        title: Text(loc.home),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PillActionButton(
                  icon: Icons.restaurant_menu,
                  label: loc.browseMenu,
                  routeName: '/menu',
                ),
                const SizedBox(height: 22),
                _PillActionButton(
                  icon: Icons.event_seat,
                  label: loc.reserveTable,
                  routeName: '/reserve',
                ),
                const SizedBox(height: 22),
                _PillActionButton(
                  icon: Icons.person_outline,
                  label: loc.viewProfileBtn,
                  routeName: '/profile',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(activeIndex: 0),
    );
  }
}

class _PillActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String routeName;

  const _PillActionButton({
    required this.icon,
    required this.label,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: FilledButton.icon(
        onPressed: () => Navigator.pushNamed(context, routeName),
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: kDeepBlue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
    );
  }
}
