// lib/main_updated.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Existing imports
import 'login.dart';
import 'signup_screen.dart';
import 'homepage.dart';
import 'menu.dart';
import 'cart.dart';
import 'checkout.dart';
import 'cart_provider.dart';

// New imports for Option A features
import 'app_localizations.dart';
import 'language_provider.dart';
import 'profile_settings.dart';
import 'feedback_screen.dart';
import 'reserve_table_screen.dart';

void main() => runApp(const App());

const _aqua = Color(0xFFBDEDF0);
const _deepBlue = Color(0xFF146C72);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()), // NEW: Language provider
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'SeaFeast',
            debugShowCheckedModeBanner: false,

            // NEW: Localization support (FR4 & FR5)
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,

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
            home: const LandingScreen(),
            routes: {
              '/login/customer': (_) => const CustomerLoginScreen(),
              '/login/admin': (_) => const AdminLoginScreen(),
              '/signup': (_) => const SignUpScreen(),
              '/home': (_) => const HomePage(),
              '/menu': (_) => const MenuScreen(),
              '/cart': (_) => const CartScreen(),
              '/checkout': (_) => const CheckoutScreen(),
              '/profile': (_) => const ProfileSettingsScreen(),

              // NEW ROUTES (Option A features)
              '/feedback': (_) => const FeedbackScreen(),        // FR22
              '/reserve': (_) => const ReserveTableScreen(),     // FR23 & FR24
            },
          );
        },
      ),
    );
  }
}