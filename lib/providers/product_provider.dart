import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/services/database/database.dart';

class ProductProvider extends ChangeNotifier {
  DatabaseService services = DatabaseService();
  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  FutureVoid createProduct({required Product product, required List<File> imgFiles}) async {
    try {
      setLoading(true);
      await services.createProduct(product: product, imageFiles: imgFiles);
      notifyListeners();
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setLoading(false);
    }
  }
}
