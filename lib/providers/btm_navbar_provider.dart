import 'package:flutter/material.dart';

class BtmNavbarProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void changeIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }
}
