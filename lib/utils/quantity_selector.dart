import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final Function(int quantity)? onChanged;

  const QuantitySelector({super.key, this.onChanged});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
      widget.onChanged?.call(quantity);
    });
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onChanged?.call(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: quantity > 1 ? decrement : null,
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: increment,
        ),
      ],
    );
  }
}
