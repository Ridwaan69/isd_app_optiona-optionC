// lib/homepage.dart
import 'package:flutter/material.dart';
import 'app_bottom_bar.dart'; // <-- added


// Local colors
const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  SizedBox(height: 8),
                  Text(
                    'SeaFeast',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text('Welcome Peter Parker!', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: kAqua,
        elevation: 0,
        centerTitle: true,
        title: const Text('Home'),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _PillActionButton(
                  icon: Icons.restaurant_menu,
                  label: 'Browse menu',
                  routeName: '/menu',
                ),
                SizedBox(height: 22),
                _PillActionButton(
                  icon: Icons.event_seat,
                  label: 'Reserve Table',
                  routeName: '/reserve',
                ),
                SizedBox(height: 22),
                _PillActionButton(
                  icon: Icons.person_outline,
                  label: 'View Profile',
                  routeName: '/profile',
                ),
              ],
            ),
          ),
        ),
      ),

      // ---------- CHANGED: use AppBottomBar ----------
      bottomNavigationBar: AppBottomBar(
        activeIndex: 0
      ),
      // ----------------------------------------------
    );
  }
}

/* Reusable pill-styled button */
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
