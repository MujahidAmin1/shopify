import 'package:flutter/material.dart';
import 'package:shopify/utils/price_format.dart';

class OrderSummarySection extends StatelessWidget {
  final double price;
  final int quantity;
  final VoidCallback onPlaceOrder;

  const OrderSummarySection({
    super.key,
    required this.price,
    required this.quantity,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoRow('Price', formatNairaPrice(price)),
          const SizedBox(height: 8),
          _buildInfoRow('Quantity', quantity.toString()),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onPlaceOrder,
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
