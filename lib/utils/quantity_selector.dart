import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final Function(int quantity)? onChanged;

  const QuantitySelector({super.key, this.onChanged, required this.quantity});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  void increment() {
    int quantity = widget.quantity;
    setState(() {
      quantity++;
      widget.onChanged?.call(quantity);
    });
  }

  void decrement() {
    int quantity = widget.quantity;
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onChanged?.call(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  final quantity = widget.quantity;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: quantity > 1 ? decrement : null,
          icon: const Icon(Icons.remove),
          color: quantity > 1
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).disabledColor,
        ),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          onPressed: increment,
          icon: const Icon(Icons.add),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}
}
