import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/modal/ui/order_model.dart';
import 'package:shopping_app/resource/provider/order_history_provider.dart';
import 'package:shopping_app/ui/place_order_screen.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/constants.dart';
import 'package:shopping_app/utils/styles.dart';

class PaymentScreen extends StatefulWidget {
  final double totalPrice;

  const PaymentScreen({required this.totalPrice, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _paymentMethods = [
    {'label': 'Credit / Debit Card', 'icon': Icons.credit_card},
    {'label': 'PayPal', 'icon': Icons.account_balance_wallet},
    {'label': 'Cash on Delivery', 'icon': Icons.local_shipping},
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Payment', style: headlineTextStyleSemiBold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: brandColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: brandColor.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Total', style: headlineTextStyle),
                      Text(
                        '${AppConstants.dollarText}${widget.totalPrice.toStringAsFixed(2)}',
                        style: headlineTextStyleBold,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment method
                const Text('Payment Method', style: headlineTextStyleSemiBold),
                const SizedBox(height: 12),
                ...List.generate(_paymentMethods.length, (i) {
                  final method = _paymentMethods[i];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMethod = i),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedMethod == i ? brandColor.withAlpha(30) : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedMethod == i ? brandColor : Theme.of(context).dividerColor,
                          width: _selectedMethod == i ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(method['icon'] as IconData,
                              color: _selectedMethod == i ? brandColor : Colors.grey),
                          const SizedBox(width: 12),
                          Text(method['label'] as String, style: titleTextStyle),
                          const Spacer(),
                          if (_selectedMethod == i)
                            const Icon(Icons.check_circle, color: brandColor, size: 20),
                        ],
                      ),
                    ),
                  );
                }),

                // Card details form (only for credit card)
                if (_selectedMethod == 0) ...[
                  const SizedBox(height: 20),
                  const Text('Card Details', style: headlineTextStyleSemiBold),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _cardNumberController,
                    label: 'Card Number',
                    hint: '1234 5678 9012 3456',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    validator: (v) => (v == null || v.length < 16) ? 'Enter a valid card number' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _cardHolderController,
                    label: 'Cardholder Name',
                    hint: 'John Doe',
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter cardholder name' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _expiryController,
                          label: 'Expiry (MM/YY)',
                          hint: '12/26',
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(5)],
                          validator: (v) => (v == null || v.length < 5) ? 'Invalid expiry' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _cvvController,
                          label: 'CVV',
                          hint: '123',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          obscureText: true,
                          validator: (v) => (v == null || v.length < 3) ? 'Invalid CVV' : null,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Place Order', style: TextStyle(color: kTextColor)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _placeOrder() {
    if (_selectedMethod == 0 && !(_formKey.currentState?.validate() ?? false)) return;

    final methodLabel = _paymentMethods[_selectedMethod]['label'] as String;
    final cartMap = Map<dynamic, int>.from(Cart().itemsMap);
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      totalPrice: widget.totalPrice,
      paymentMethod: methodLabel,
      items: cartMap.entries
          .map((e) => OrderItem(product: e.key, quantity: e.value))
          .toList(),
    );

    Provider.of<OrderHistoryProvider>(context, listen: false).addOrder(order);
    Cart().itemsMap.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceOrderScreen(totalPrice: widget.totalPrice),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter> inputFormatters = const [],
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      validator: validator,
      style: autoCompleteTextStyle,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: searchHintTextStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandColor, width: 2),
        ),
      ),
    );
  }
}
