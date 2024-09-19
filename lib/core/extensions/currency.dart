import 'package:moniman/core/enums/currencies.dart';

extension CurrencyExtension on Currencies {
  String get symbol {
    switch (this) {
      case Currencies.usd:
        return '\$';
      case Currencies.xaf:
        return 'FCFA';
    }
  }
}
