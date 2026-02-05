// lib/feedback_screen.dart
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import '/app_bottom_bar.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();
  double _rating = 5.0;

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final loc = AppLocalizations.of(context);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    // Show success dialog
    await showDialog(
      context: context,
      builder: (_) {
        final dialogLoc = AppLocalizations.of(context);
        return AlertDialog(
          icon: const Icon(Icons.check_circle, size: 48, color: Colors.green),
          title: Text(dialogLoc.feedbackSubmitted),
          content: Text(dialogLoc.feedbackAppreciation),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kDeepBlue),
              onPressed: () => Navigator.pop(context),
              child: Text(dialogLoc.ok),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    // Clear form and go back
    _commentsController.clear();
    setState(() => _rating = 5.0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: Text(loc.feedback),
      ),
      bottomNavigationBar: AppBottomBar(activeIndex: 1),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.rate_review, size: 48, color: kDeepBlue),
                    const SizedBox(height: 12),
                    Text(
                      loc.giveFeedback,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: kDeepBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      loc.helpUsImprove,
                      style: const TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Rating Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.rateExperience,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kDeepBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Star Rating Display
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starValue = index + 1;
                          return IconButton(
                            icon: Icon(
                              starValue <= _rating ? Icons.star : Icons.star_border,
                              size: 40,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setState(() => _rating = starValue.toDouble());
                            },
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Rating Slider
                    Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      activeColor: kDeepBlue,
                      inactiveColor: kDeepBlue.withOpacity(0.3),
                      label: _rating.toInt().toString(),
                      onChanged: (value) {
                        setState(() => _rating = value);
                      },
                    ),

                    // Rating Text
                    Center(
                      child: Text(
                        _getRatingText(_rating.toInt(), loc),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDeepBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Comments Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.comments,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kDeepBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _commentsController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: loc.commentsHint,
                        filled: true,
                        fillColor: const Color(0xFFF5F9FA),
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE0E6EF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: kDeepBlue, width: 1.5),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return loc.pleaseShareFeedback;
                        }
                        if (v.trim().length < 10) {
                          return loc.provideDetailedFeedback;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kDeepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitFeedback,
                  child: Text(
                    loc.submitFeedback,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating, AppLocalizations loc) {
    switch (rating) {
      case 1:
        return loc.ratingPoor;
      case 2:
        return loc.ratingFair;
      case 3:
        return loc.ratingGood;
      case 4:
        return loc.ratingVeryGood;
      case 5:
        return loc.ratingExcellent;
      default:
        return '';
    }
  }
}