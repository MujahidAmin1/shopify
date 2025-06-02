import 'package:intl/intl.dart';

String formatNairaPrice(double price) {
  final formatCurrency = NumberFormat.currency(
    locale: 'en_NG', // Nigerian locale
    symbol: '₦',
    decimalDigits: 2, // set to 0 if you want no decimal places
  );
  return formatCurrency.format(price);
}
