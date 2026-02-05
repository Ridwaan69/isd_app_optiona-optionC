// lib/profile_settings_updated.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'language_provider.dart';
import '/app_bottom_bar.dart';

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
  final _emailCtrl = TextEditingController(text: 'peter.parker@gmail.com');
  final _dobCtrl = TextEditingController(text: '23/05/2000');

  Uint8List? _photoBytes;
  final _picker = ImagePicker();

  String _flagFor(String code) {
    switch (code) {
      case 'fr':
        return '🇫🇷';
      case 'en':
        return '🇬🇧';
      case 'es':
        return '🇪🇸';
      default:
        return '🌐';
    }
  }

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
            if (!kIsWeb)
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

  Future<void> _showLanguageDialog() async {
    final langProvider = context.read<LanguageProvider>();
    final loc = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              languageCode: 'en',
              languageName: loc.english,
              currentCode: langProvider.currentLocale.languageCode,
              onTap: () {
                langProvider.changeLanguage('en');
                Navigator.pop(context);
              },
            ),
            const Divider(),
            _LanguageOption(
              languageCode: 'fr',
              languageName: loc.french,
              currentCode: langProvider.currentLocale.languageCode,
              onTap: () {
                langProvider.changeLanguage('fr');
                Navigator.pop(context);
              },
            ),
            const Divider(),
            _LanguageOption(
              languageCode: 'es',
              languageName: loc.spanish,
              currentCode: langProvider.currentLocale.languageCode,
              onTap: () {
                langProvider.changeLanguage('es');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.profileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: Text(loc.profile),
      ),
      bottomNavigationBar: AppBottomBar(activeIndex: 1),
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
                  _FieldLabel(loc.name),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: _inputStyle(),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel(loc.email),
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

                  _FieldLabel(loc.dateOfBirth),
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
                  const SizedBox(height: 16),

                  // Language Selection (FR4)
                  _FieldLabel(loc.language),
                  InkWell(
                    onTap: _showLanguageDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _flagFor(langProvider.currentLocale.languageCode),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            langProvider.currentLanguageName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down, color: kDeepBlue),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Feedback Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kDeepBlue, width: 2),
                      foregroundColor: kDeepBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.rate_review),
                    label: Text(loc.giveFeedback),
                    onPressed: () => Navigator.pushNamed(context, '/feedback'),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3A59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _save,
                      child: Text(loc.saveChanges),
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
  const _FieldLabel(this.text);

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

class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final String currentCode;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.currentCode,
    required this.onTap,
  });

  String get _flag {
    switch (languageCode) {
      case 'fr':
        return '🇫🇷';
      case 'en':
        return '🇬🇧';
      case 'es':
        return '🇪🇸';
      default:
        return '🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = languageCode == currentCode;

    return ListTile(
      leading: Text(
        _flag,
        style: const TextStyle(fontSize: 20),
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? kDeepBlue : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: kDeepBlue)
          : null,
      onTap: onTap,
    );
  }
}
