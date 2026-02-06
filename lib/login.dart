// lib/login_updated.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // SUPABASE ADDITION
import 'language_provider.dart';
import 'app_localizations.dart';

const _aqua = Color(0xFFBDEDF0);
const _deepBlue = Color(0xFF146C72);

InputDecoration _authInput(String label) => InputDecoration(
  labelText: label,
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFDFE9EB)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: _deepBlue, width: 1.6),
  ),
);

/* ================= AUTH CARD (UNCHANGED) ================= */

class AuthCard extends StatelessWidget {
  final String title;
  final Widget form;
  final Widget? footer;
  final VoidCallback onBack;
  final VoidCallback onPrimary;
  final String primaryText;
  const AuthCard({
    super.key,
    required this.title,
    required this.form,
    this.footer,
    required this.onBack,
    required this.onPrimary,
    this.primaryText = 'SIGN IN',
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          color: _aqua,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _deepBlue,
                  ),
                ),
                const SizedBox(height: 12),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 96,
                  color: _deepBlue,
                ),
                const SizedBox(height: 12),
                form,
                const SizedBox(height: 16),
                FilledButton(onPressed: onPrimary, child: Text(primaryText)),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: onBack, child: Text(loc.backBtn)),
                if (footer != null) ...[const SizedBox(height: 10), footer!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= LANDING SCREEN (UNCHANGED) ================= */

/* ================= LANDING SCREEN (UNCHANGED) ================= */

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: _aqua,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Sea\nFeast',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _deepBlue,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    _getWelcomeText(
                      languageProvider.currentLocale.languageCode,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _deepBlue,
                    ),
                  ),

                  const SizedBox(height: 28),

                  FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/login/customer'),
                    child: Text(
                      _getCustomerText(
                        languageProvider.currentLocale.languageCode,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/login/admin'),
                    child: Text(
                      _getAdminText(
                        languageProvider.currentLocale.languageCode,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _deepBlue.withOpacity(0.3)),
                      ),
                      child: DropdownButton<String>(
                        value: languageProvider.currentLocale.languageCode,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: _deepBlue,
                        ),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'fr',
                            child: Text('🇫🇷 Français'),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('🇬🇧 English'),
                          ),
                          DropdownMenuItem(
                            value: 'es',
                            child: Text('🇪🇸 Español'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            languageProvider.changeLanguage(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getWelcomeText(String lang) {
    switch (lang) {
      case 'fr':
        return 'Bienvenue à SeaFeast';
      case 'es':
        return 'Bienvenido a SeaFeast';
      default:
        return 'Welcome to SeaFeast';
    }
  }

  String _getCustomerText(String lang) {
    switch (lang) {
      case 'fr':
        return 'Client';
      case 'es':
        return 'Cliente';
      default:
        return 'Customer';
    }
  }

  String _getAdminText(String lang) => 'Admin';
}

/* ================= ERROR MESSAGE MAPPER ================= */
/* SAFE ADDITION – no side effects, easy merge */

String _friendlyAuthError(Object error) {
  if (error is AuthException) {
    final msg = error.message.toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return 'Invalid email or password';
    }
    if (msg.contains('user not found')) {
      return 'Account does not exist';
    }
  }

  if (error.toString().contains('Not a customer')) {
    return 'This is not a customer account';
  }
  if (error.toString().contains('Not an admin')) {
    return 'This is not an admin account';
  }
  if (error.toString().contains('SocketException')) {
    return 'Network error. Please try again.';
  }

  return 'Something went wrong. Please try again.';
}

/* ================= CUSTOMER LOGIN ================= */

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _form = GlobalKey<FormState>();
  String email = '', pw = '';
  bool loading = false;

  final _supabase = Supabase.instance.client;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      final auth = await _supabase.auth.signInWithPassword(
        email: email,
        password: pw,
      );

      final user = auth.user;
      if (user == null) throw Exception('Login failed');

      final profile = await _supabase
          .from('user_profiles')
          .select('role')
          .eq('id', user.id)
          .single();

      if (profile['role'] != 'customer') {
        await _supabase.auth.signOut();
        throw Exception('Not a customer');
      }

      if (!mounted) return;
      setState(() => loading = false);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);

      // FRIENDLY ERROR DISPLAY
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyAuthError(e)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: _aqua,
      body: SafeArea(
        child: AuthCard(
          title: loc.signIn,
          onBack: () => Navigator.pop(context),
          onPrimary: loading ? () {} : _submit,
          primaryText: loading ? 'Signing in...' : loc.login,
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.dontHaveAccount),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text(loc.signUpSmall),
              ),
            ],
          ),
          form: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: _authInput(loc.email),
                  onChanged: (v) => email = v.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: _authInput(loc.password),
                  obscureText: true,
                  onChanged: (v) => pw = v,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= ADMIN LOGIN ================= */

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _form = GlobalKey<FormState>();
  String email = '',
      pw = ''; // small change here I changed staffID variable to email.
  bool loading = false;

  final _supabase = Supabase.instance.client;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      final auth = await _supabase.auth.signInWithPassword(
        email: email, // small change here I changed staffID variable to email.
        password: pw,
      );

      final user = auth.user;
      if (user == null) throw Exception('Login failed');

      final profile = await _supabase
          .from('user_profiles')
          .select('role')
          .eq('id', user.id)
          .single();

      if (profile['role'] != 'admin') {
        await _supabase.auth.signOut();
        throw Exception('Not an admin');
      }

      if (!mounted) return;
      setState(() => loading = false);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyAuthError(e)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: _aqua,
      body: SafeArea(
        child: AuthCard(
          title: loc.adminLogin,
          onBack: () => Navigator.pop(context),
          onPrimary: loading ? () {} : _submit,
          primaryText: loading ? loc.signingIn : loc.login,
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.dontHaveAccount),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text(loc.signUpSmall),
              ),
            ],
          ),
          form: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: _authInput(loc.staffId),
                  onChanged: (v) => email = v
                      .trim(), // small change here I changed staffID variable to email.
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: _authInput(loc.password),
                  obscureText: true,
                  onChanged: (v) => pw = v,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
