import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import '/app_bottom_bar.dart';
import 'app_localizations.dart';

//import for option A
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final loc = AppLocalizations.of(context);
    final subtotal = context.watch<CartProvider>().subtotal;
    const currency = 'Rs ';
    const deliveryCharge = 50.0;
    const discount = 0.0;
    final total =
        (subtotal + deliveryCharge - discount).clamp(0, double.infinity)
            as double;

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: Text(loc.checkout),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const SizedBox(height: 6),
          Text(
            loc.paymentOption,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _PaymentTile(
                  label: loc.cash,
                  icon: Icons.payments_outlined,
                  selected: _method == PaymentMethod.cash,
                  onTap: () => setState(() => _method = PaymentMethod.cash),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentTile(
                  label: loc.card,
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
                              ? loc.noCard
                              : '**** **** **** ${_savedCard!.last4}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _savedCard == null
                        ? loc.addCard
                        : '${loc.cardHolder}: ${_savedCard!.holderName}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(
                      _savedCard == null ? loc.addNew : loc.replaceCard,
                    ),
                    onPressed: () async {
                      final added = await Navigator.push<CardInfo>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddCardScreen(initial: _savedCard),
                        ),
                      );
                      if (added != null && mounted) {
                        setState(() => _savedCard = added);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(loc.cardSaved)));
                      }
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '${loc.total.toUpperCase()}:',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$currency${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
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
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              //changed onpressed() to save orders to supabase
              //did not change anything else, functionality and is the same
              //SAFE TO KEEP
              onPressed: () async {
                if (_method == PaymentMethod.card && _savedCard == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.pleaseAddCardOrCash)),
                  );
                  return;
                }

                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      _method == PaymentMethod.cash
                          ? loc.confirmOrder
                          : loc.confirmPayment,
                    ),
                    content: Text(
                      _method == PaymentMethod.cash
                          ? loc.youChoseCash
                          : '${loc.payWithCard} ${_savedCard!.last4}?',
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(loc.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF146C72),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(loc.confirm),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                if (ok == true && context.mounted) {
                  // -------------------- SAVE ORDER TO SUPABASE -------------------- //
                  try {
                    final supabase =
                        Supabase.instance.client; // SAFE TO KEEP DURING MERGING
                    final user = supabase.auth.currentUser;
                    if (user != null) {
                      // Insert order
                      final order = await supabase
                          .from('orders')
                          .insert({
                            'user_id': user.id,
                            'total': total,
                            'status': 'pending',
                          })
                          .select()
                          .single();

                      final orderId = order['id'];

                      // Insert order items
                      final cartItems = context.read<CartProvider>().lines;
                      if (cartItems.isNotEmpty) {
                        final itemsToInsert = cartItems
                            .map(
                              (line) => {
                                'order_id': orderId,
                                'menu_item_id': line.item.id,
                                'name': line.item.name, // store menu name
                                'price': line.item.price,
                                'quantity': line.qty,
                                'selected_options':
                                    line.selected, // Dart List<String> -> JSONB
                              },
                            )
                            .toList();

                        await supabase
                            .from('order_items')
                            .insert(itemsToInsert);
                      }
                    }
                  } catch (e) {
                    debugPrint(
                      'Error saving order: $e',
                    ); // SAFE TO KEEP DURING MERGING
                  }
                  // ---------------------------------------------------------------- //

                  context.read<CartProvider>().clear();
                  if (!mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      icon: const Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green,
                      ),
                      title: Text(
                        _method == PaymentMethod.cash
                            ? loc.orderConfirmed
                            : loc.paymentSuccessful,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(loc.orderPlaced),
                          const SizedBox(height: 16),
                          Text(
                            loc.wouldYouRate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.grey),
                                  foregroundColor: Colors.black87,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(loc.maybeLater),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF146C72),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/feedback');
                                },
                                child: Text(loc.rateNow),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },

              child: Text(
                _method == PaymentMethod.cash
                    ? loc.confirmOrder
                    : loc.confirmOrderBtn,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomBar(activeIndex: 2),
    );
  }
}

/* --------------- Add Card --------------- */

class CardInfo {
  final String holderName;
  final String number;
  final String exp;
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
  late final TextEditingController _name = TextEditingController(
    text: widget.initial?.holderName ?? 'Peter Parker',
  );
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
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: kAqua,
      appBar: AppBar(
        backgroundColor: kAqua,
        centerTitle: true,
        title: Text(loc.addCardTitle),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            _FieldLabel(loc.cardHolderName),
            TextFormField(
              controller: _name,
              decoration: _input('Peter Parker'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? loc.required : null,
            ),
            const SizedBox(height: 14),

            _FieldLabel(loc.cardNumber),
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              decoration: _input('2134 1234 1234 1234'),
              validator: (v) => (v == null || v.replaceAll(' ', '').length < 16)
                  ? loc.enterValidNumber
                  : null,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(loc.expireDate),
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
                            ? loc.invalidDate
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
                      _FieldLabel(loc.cvc),
                      TextFormField(
                        controller: _cvc,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _input('***'),
                        validator: (v) =>
                            (v == null || v.length < 3) ? loc.invalidCvc : null,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                child: Text(loc.addAndPay),
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12,
          letterSpacing: .3,
        ),
      ),
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
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: kDeepBlue,
              ),
            ),
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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = newValue.text.replaceAll('/', '');
    if (d.length > 6) d = d.substring(0, 6);
    if (d.length >= 3) d = '${d.substring(0, 2)}/${d.substring(2)}';
    return TextEditingValue(
      text: d,
      selection: TextSelection.collapsed(offset: d.length),
    );
  }
}
