// lib/signup_screen.dart
import 'package:flutter/material.dart';

/// Colors to match your other screens
const _aqua = Color(0xFFBDEDF0);
const _deepBlue = Color(0xFF146C72);

InputDecoration _authInput(String label) => InputDecoration(
  labelText: label,
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  enabledBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color(0xFFDFE9EB)),
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: _deepBlue, width: 1.6),
  ),
);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _pw = TextEditingController();
  final _pw2 = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _pw.dispose();
    _pw2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    // TODO: replace with your API call to create account
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _loading = false);

    // After successful sign-up, go to the login screen (as in the mockup text)
    Navigator.pushReplacementNamed(context, '/login/customer');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: _aqua,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: _aqua,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Create your account',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _deepBlue)),
                      const SizedBox(height: 12),
                      const Icon(Icons.account_circle_outlined, size: 96, color: _deepBlue),
                      const SizedBox(height: 12),

                      // First / Last name (side-by-side like the mockup)
                      LayoutBuilder(
                        builder: (context, c) {
                          final twoCols = c.maxWidth >= 360;
                          if (twoCols) {
                            return Row(
                              children: [
                                Expanded(child: TextFormField(
                                  controller: _first,
                                  decoration: _authInput('First Name'),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                                )),
                                const SizedBox(width: 10),
                                Expanded(child: TextFormField(
                                  controller: _last,
                                  decoration: _authInput('Last Name'),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                                )),
                              ],
                            );
                          }
                          // Small screens: stack vertically
                          return Column(
                            children: [
                              TextFormField(
                                controller: _first,
                                decoration: _authInput('First Name'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _last,
                                decoration: _authInput('Last Name'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _email,
                        decoration: _authInput('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pw,
                        decoration: _authInput('Password'),
                        obscureText: true,
                        validator: (v) =>
                        (v == null || v.length < 6) ? 'Min 6 characters' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pw2,
                        decoration: _authInput('Re-enter password'),
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Confirm your password';
                          if (v != _pw.text) return 'Passwords do not match';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Buttons row: Sign Up + Cancel
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox(
                                  height: 18, width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('Sign Up'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _loading ? null : () => Navigator.pop(context),
                              child: const Text('CANCEL'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Footer: Already have an account? Sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?', style: theme.textTheme.bodyMedium?.copyWith(color: _deepBlue)),
                          TextButton(
                            onPressed: _loading ? null : () => Navigator.pushReplacementNamed(context, '/login/customer'),
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
