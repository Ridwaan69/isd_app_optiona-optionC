// lib/login_screens.dart
import 'package:flutter/material.dart';


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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          color: _aqua,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _deepBlue)),
                const SizedBox(height: 12),
                const Icon(Icons.account_circle_outlined, size: 96, color: _deepBlue),
                const SizedBox(height: 12),
                form,
                const SizedBox(height: 16),
                FilledButton(onPressed: onPrimary, child: Text(primaryText)),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: onBack, child: const Text('BACK')),
                if (footer != null) ...[
                  const SizedBox(height: 10),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------- Screens ---------

/// Welcome with Customer/Admin buttons
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
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
                  Container(
                    width: 110, height: 110,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    alignment: Alignment.center,
                    child: const Text('Sea\nFeast',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _deepBlue, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 18),
                  const Text('Welcome to SeaFeast',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _deepBlue)),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/login/customer'),
                    child: const Text('Customer'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/login/admin'),
                    child: const Text('Admin'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Customer: Email + Password
class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}
class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _form = GlobalKey<FormState>();
  String email = '', pw = '';
  bool loading = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home'); // <-- go to Home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _aqua,
      body: SafeArea(
        child: AuthCard(
          title: 'Sign in to your account',
          onBack: () => Navigator.pop(context),
          onPrimary: loading ? (){} : _submit,
          primaryText: loading ? 'Signing in...' : 'SIGN IN',
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Sign up'),
              ),

            ],
          ),
          form: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: _authInput('Email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => email = v.trim(),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: _authInput('Password'),
                  obscureText: true,
                  onChanged: (v) => pw = v,
                  validator: (v) => (v == null || v.length < 4) ? 'Min 4 characters' : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Admin: Staff ID + Password
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _form = GlobalKey<FormState>();
  String staffId = '', pw = '';
  bool loading = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home'); // <-- go to Home
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _aqua,
      body: SafeArea(
        child: AuthCard(
          title: 'Admin Log in',
          onBack: () => Navigator.pop(context),
          onPrimary: loading ? (){} : _submit,
          primaryText: loading ? 'Signing in...' : 'SIGN IN',
          form: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: _authInput('Staff ID'),
                  onChanged: (v) => staffId = v.trim(),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter Staff ID' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: _authInput('Password'),
                  obscureText: true,
                  onChanged: (v) => pw = v,
                  validator: (v) => (v == null || v.length < 4) ? 'Min 4 characters' : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
