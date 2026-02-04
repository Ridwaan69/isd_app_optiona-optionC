// lib/reserve_table_screen.dart
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import '/app_bottom_bar.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

class ReserveTableScreen extends StatefulWidget {
  const ReserveTableScreen({super.key});

  @override
  State<ReserveTableScreen> createState() => _ReserveTableScreenState();
}

class _ReserveTableScreenState extends State<ReserveTableScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  int _numberOfGuests = 2;

  // Available time slots (FR23)
  final List<String> _timeSlots = [
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
  ];

  // Mock availability data (FR23)
  bool _isSlotAvailable(String slot) {
    // Simulate some slots being unavailable
    final unavailableSlots = ['12:30 PM', '7:00 PM', '8:00 PM'];
    return !unavailableSlots.contains(slot);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null; // Reset time when date changes
      });
    }
  }

  Future<void> _bookTable() async {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    // Show success dialog
    final loc = AppLocalizations.of(context);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, size: 48, color: Colors.green),
        title: Text(loc.bookingConfirmed),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.bookingDetails),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kAqua,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _BookingDetailRow(
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: _formatDate(_selectedDate),
                  ),
                  const SizedBox(height: 8),
                  _BookingDetailRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: _selectedTimeSlot!,
                  ),
                  const SizedBox(height: 8),
                  _BookingDetailRow(
                    icon: Icons.people,
                    label: 'Guests',
                    value: '$_numberOfGuests ${loc.guests}',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kDeepBlue),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: Text(loc.bookTable),
      ),
      bottomNavigationBar: AppBottomBar(activeIndex: 0),
      body: SafeArea(
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
                  const Icon(Icons.event_seat, size: 48, color: kDeepBlue),
                  const SizedBox(height: 12),
                  Text(
                    loc.bookTable,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Reserve your table for a delightful dining experience',
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date Selection
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
                    loc.selectDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F9FA),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0E6EF)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: kDeepBlue),
                          const SizedBox(width: 12),
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down, color: kDeepBlue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Number of Guests
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
                    loc.numberOfGuests,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_numberOfGuests > 1) {
                            setState(() => _numberOfGuests--);
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: kDeepBlue,
                        iconSize: 32,
                      ),
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kAqua,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$_numberOfGuests',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDeepBlue,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_numberOfGuests < 12) {
                            setState(() => _numberOfGuests++);
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: kDeepBlue,
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Available Time Slots (FR23)
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
                    loc.availableSlots,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _timeSlots.map((slot) {
                      final isAvailable = _isSlotAvailable(slot);
                      final isSelected = _selectedTimeSlot == slot;

                      return InkWell(
                        onTap: isAvailable
                            ? () {
                          setState(() => _selectedTimeSlot = slot);
                        }
                            : null,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: !isAvailable
                                ? Colors.grey.shade200
                                : isSelected
                                ? kDeepBlue
                                : kAqua,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !isAvailable
                                  ? Colors.grey.shade400
                                  : isSelected
                                  ? kDeepBlue
                                  : const Color(0xFFE0E6EF),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              color: !isAvailable
                                  ? Colors.grey.shade500
                                  : isSelected
                                  ? Colors.white
                                  : kDeepBlue,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              decoration: !isAvailable
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_timeSlots.where((s) => !_isSlotAvailable(s)).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Unavailable',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Book Button (FR24)
            SizedBox(
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: kDeepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _bookTable,
                child: Text(
                  loc.bookNow,
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
    );
  }
}

class _BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kDeepBlue),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: kDeepBlue,
            ),
          ),
        ),
      ],
    );
  }
}