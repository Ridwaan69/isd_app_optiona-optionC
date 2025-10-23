import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens already in your project
import 'login.dart';           // LandingScreen, CustomerLoginScreen, AdminLoginScreen
import 'signup_screen.dart';   // SignUpScreen
import 'homepage.dart';        // HomePage
import 'profile_settings.dart';// ProfileSettingsScreen

// New files we created
import 'menu.dart';            // MenuScreen
import 'cart.dart';       // CartScreen
import 'cart_provider.dart';   // CartProvider

void main() => runApp(const App());

/* ---------------- Theme bits ---------------- */
const _aqua = Color(0xFFBDEDF0);
const _deepBlue = Color(0xFF146C72);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),               // 👈 provides cart to whole app
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

        // keep your landing/home flow as-is
        home: const LandingScreen(),

        routes: {
          '/login/customer': (_) => const CustomerLoginScreen(),
          '/login/admin': (_) => const AdminLoginScreen(),
          '/signup': (_) => const SignUpScreen(),
          '/home': (_) => const HomePage(),

          // our pages
          '/menu': (_) => const MenuScreen(),
          '/cart': (_) => const CartScreen(),
          '/profile': (_) => const ProfileSettingsScreen(),
        },
      ),
    );
  }
}
