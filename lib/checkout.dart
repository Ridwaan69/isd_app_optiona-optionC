import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

const kAqua = Color(0xFFBDEDF0);
const kDeepBlue = Color(0xFF146C72);

enum PaymentMethod { cash, card }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _method = PaymentMethod.card;
  CardInfo? _savedCard;

  @override
  Widget build(BuildContext context) {
    final subtotal = context.watch<CartProvider>().subtotal;
    const currency = 'Rs ';

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const SizedBox(height: 6),
          const Text('Choose your payment option',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _PaymentTile(
                  label: 'Cash',
                  icon: Icons.payments_outlined,
                  selected: _method == PaymentMethod.cash,
                  onTap: () => setState(() => _method = PaymentMethod.cash),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentTile(
                  label: 'Mastercard',
                  icon: Icons.credit_card,
                  selected: _method == PaymentMethod.card,
                  onTap: () => setState(() => _method = PaymentMethod.card),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_method == PaymentMethod.card)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // card illustration
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF103D5D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _savedCard == null
                              ? 'No master card added'
                              : '**** **** **** ${_savedCard!.last4}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _savedCard == null
                        ? 'You can add a mastercard and save it for later'
                        : 'Card holder: ${_savedCard!.holderName}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(_savedCard == null ? 'ADD NEW' : 'REPLACE CARD'),
                    onPressed: () async {
                      final added = await Navigator.push<CardInfo>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddCardScreen(initial: _savedCard),
                        ),
                      );
                      if (added != null && mounted) {
                        setState(() => _savedCard = added);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Card saved')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
          Row(
            children: [
              const Text('TOTAL:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(
                '$currency${subtotal.toStringAsFixed(2)}',
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 14),

          SizedBox(
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kDeepBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                if (_method == PaymentMethod.card && _savedCard == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please add a card or choose Cash')),
                  );
                  return;
                }
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirm payment'),
                    content: Text(_method == PaymentMethod.cash
                        ? 'You chose Cash. Confirm the order?'
                        : 'Pay with **** **** **** ${_savedCard!.last4}?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Confirm')),
                    ],
                  ),
                );
                if (ok == true && context.mounted) {
                  context.read<CartProvider>().clear();
                  if (!mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      icon: const Icon(Icons.check_circle,
                          size: 48, color: Colors.green),
                      title: const Text('Payment successful'),
                      content: const Text('Your order has been placed!'),
                      actions: [
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  Navigator.pop(context); // back to cart
                }
              },
              child: const Text('Pay and Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Add Card ---------------- */

class CardInfo {
  final String holderName;
  final String number; // e.g. "2134 1234 1234 1234"
  final String exp;    // "mm/yyyy"
  final String cvc;

  CardInfo({
    required this.holderName,
    required this.number,
    required this.exp,
    required this.cvc,
  });

  String get last4 {
    final digits = number.replaceAll(' ', '');
    return digits.substring(digits.length - 4);
  }
}

class AddCardScreen extends StatefulWidget {
  final CardInfo? initial;
  const AddCardScreen({super.key, this.initial});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name =
  TextEditingController(text: widget.initial?.holderName ?? 'Peter Parker');
  final _number = TextEditingController();
  final _exp = TextEditingController();
  final _cvc = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _number.text = widget.initial!.number;
      _exp.text = widget.initial!.exp;
      _cvc.text = widget.initial!.cvc;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    _exp.dispose();
    _cvc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: const Text('Add Card'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const _FieldLabel('CARD HOLDER NAME'),
            TextFormField(
              controller: _name,
              decoration: _input('Peter Parker'),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),

            const _FieldLabel('CARD NUMBER'),
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              decoration: _input('2134 1234 1234 1234'),
              validator: (v) =>
              (v == null || v.replaceAll(' ', '').length < 16)
                  ? 'Enter a valid number'
                  : null,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('EXPIRE DATE'),
                      TextFormField(
                        controller: _exp,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ExpiryFormatter(),
                        ],
                        decoration: _input('mm/yyyy'),
                        validator: (v) =>
                        (v == null || !RegExp(r'^\d{2}/\d{4}$').hasMatch(v))
                            ? 'Invalid date'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('CVC'),
                      TextFormField(
                        controller: _cvc,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _input('***'),
                        validator: (v) =>
                        (v == null || v.length < 3) ? 'Invalid CVC' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: kDeepBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  final card = CardInfo(
                    holderName: _name.text.trim(),
                    number: _number.text.trim(),
                    exp: _exp.text.trim(),
                    cvc: _cvc.text.trim(),
                  );
                  Navigator.pop(context, card);
                },
                child: const Text('Add and Make Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

/* ---------- small widgets & formatters ---------- */

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              color: Colors.black54, fontSize: 12, letterSpacing: .3)),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: selected ? kDeepBlue : Colors.black12,
      width: selected ? 2 : 1,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: border,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: kDeepBlue),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kDeepBlue)),
            if (selected)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle, size: 18, color: kDeepBlue),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var d = newValue.text.replaceAll('/', '');
    if (d.length > 6) d = d.substring(0, 6);
    if (d.length >= 3) d = '${d.substring(0, 2)}/${d.substring(2)}';
    return TextEditingValue(
      text: d,
      selection: TextSelection.collapsed(offset: d.length),
    );
  }
}
