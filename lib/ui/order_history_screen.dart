import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/resource/provider/order_history_provider.dart';
import 'package:shopping_app/modal/ui/order_model.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: headlineTextStyleSemiBold),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Consumer<OrderHistoryProvider>(
          builder: (context, provider, _) {
            final orders = provider.orders;
            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: brandColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long_outlined, size: 60, color: brandColor),
                      ),
                      const SizedBox(height: 20),
                      const Text('No orders yet', style: headlineTextStyleSemiBold),
                      const SizedBox(height: 8),
                      const Text(
                        'Your completed orders will appear here.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final date = order.date;
    final dateStr = '${date.day}/${date.month}/${date.year}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_outlined, color: brandColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Order #${order.id.substring(order.id.length - 6)}',
                      style: titleTextStyle),
                ),
                Text('\$${order.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: brandColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.payment, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(order.paymentMethod,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _expanded ? 'Hide items' : 'View items',
                style: const TextStyle(color: brandColor, fontSize: 13),
              ),
            ),
            if (_expanded) ...[
              const Divider(height: 12),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(item.product.imageUrl,
                              width: 44, height: 44, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(item.product.name,
                              style: titleTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 8),
                        Text('x${item.quantity}',
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: brandColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
