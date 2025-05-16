import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/views/screens/create_product.dart';
import 'package:shopify/views/screens/product_detailed_screen.dart';
import 'package:shopify/views/widgets/category_chips.dart';
import 'package:shopify/views/widgets/productdisplay_widget.dart';

class Firstscreen extends StatefulWidget {
  const Firstscreen({super.key});

  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen> {
  int _selectedIndex = 0;
  DatabaseService databaseService = DatabaseService();
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
                      (value) => CategoryChips(
                        selectedColor: Color(0xff8E6CEF),
                        label:
                            "${value.name[0].toUpperCase()}${value.name.substring(1)}",
                        isSelected: _selectedIndex == value.index,
                        onTap: () {
                          setState(() {
                            _selectedIndex = value.index;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<Product>>(
                stream: databaseService.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitSpinningLines(
                      color: Colors.black,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error!.toString(),
                      style: kTextStyle(color: Colors.white),
                    ));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Tasks available'));
                  }
                  List<Product> product = snapshot.data!;
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.push(
                                ProductDetailedScreen(product: product[index]));
                          },
                          child: ProductDisplay(
                            img: product[index].imageUrls.first,
                            title: product[index].title,
                            description: product[index].description,
                            price: product[index].price,
                          ),
                        );
                      },
                    ),
                  );
                }),
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
