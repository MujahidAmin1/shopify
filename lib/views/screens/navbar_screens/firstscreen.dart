import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/views/screens/create_product.dart';

class Firstscreen extends StatefulWidget {
  const Firstscreen({super.key});

  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.search_favorite),
                  hintText: "search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
            ),
            Text("Categories", style: kTextStyle(size: 20, isBold: true)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: Category.values
                    .map(
                      (value) => ChoiceChip(
                        showCheckmark: false,
                        selectedColor: Color(0xff8E6CEF),
                        label: Text("${value.name[0].toUpperCase()}${value.name.substring(1)}"),
                        selected: _selectedIndex == value.index,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedIndex =
                                selected ? value.index : _selectedIndex;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => context.push(CreateProduct()),
              child: Text("Nav"),
            )
          ],
        ),
      ),
    );
  }
}
