import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();


  final _nameCtrl = TextEditingController(text: 'Peter Parker');
  final _emailCtrl = TextEditingController(text: 'XXXXXXXX@gmail.com');
  final _dobCtrl = TextEditingController(text: '23/05/19XX');

  Uint8List? _photoBytes; // for mobile & web
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await _chooseSource();
    if (source == null) return;

    final XFile? file = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() => _photoBytes = bytes);
  }

  Future<ImageSource?> _chooseSource() async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            if (!kIsWeb) // camera not supported on some web targets
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final selected = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      helpText: 'Select Date of Birth',
      builder: (context, child) {

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kDeepBlue,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      _dobCtrl.text =
      '${selected.day.toString().padLeft(2, '0')}/${selected.month.toString().padLeft(2, '0')}/${selected.year.toString().padLeft(4, '0')}';
      setState(() {});
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: const Text('Profile'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.person_outline))],
      ),
      bottomNavigationBar: const _AppBottomBar(activeIndex: 1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            // Avatar + edit
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: _photoBytes == null
                        ? const CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFFB9D6F0),
                      child: Icon(Icons.person, size: 56, color: kDeepBlue),
                    )
                        : CircleAvatar(
                      radius: 52,
                      backgroundImage: MemoryImage(_photoBytes!),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _pickImage,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.edit, size: 18, color: kDeepBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _FieldLabel('Name'),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: _inputStyle(),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),

                  const _FieldLabel('Email'),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: _inputStyle(
                      suffixIcon: const Icon(Icons.check_box_outline_blank, size: 18),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final val = v?.trim() ?? '';
                      if (val.isEmpty) return 'Please enter your email';
                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(val);
                      return ok ? null : 'Invalid email';
                    },
                  ),
                  const SizedBox(height: 16),

                  const _FieldLabel('Date of Birth'),
                  InkWell(
                    onTap: _pickDob,
                    child: IgnorePointer(
                      ignoring: true,
                      child: TextFormField(
                        controller: _dobCtrl,
                        decoration: _inputStyle(
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3A59),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _save,
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle({Widget? suffixIcon}) => InputDecoration(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
    ),
    suffixIcon: suffixIcon,
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: kDeepBlue,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}


/* ---------- Bottom bar (same look) ---------- */
class _AppBottomBar extends StatelessWidget {
  final int activeIndex; // 0: home, 1: profile, 2: cart
  const _AppBottomBar({required this.activeIndex});

  void _go(BuildContext context, int i) {
    if (i == activeIndex) return;
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home'); // Home
        break;
      case 1:

        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: (i) => _go(context, i),
      backgroundColor: kAqua,
      selectedItemColor: kDeepBlue,
      unselectedItemColor: kDeepBlue.withOpacity(0.6),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_rounded), label: ''),
      ],
    );
  }
}


