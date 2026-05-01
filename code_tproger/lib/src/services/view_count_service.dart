import 'package:injectable/injectable.dart';

@singleton
class ViewCountService {
  static const _groupedDigitsCount = 3;

  String format(int value) {
    final stringValue = value.toString();
    
    if (stringValue.length < 5) {
      return stringValue;
    }

    var formattedValue = '';
    var splitIndex = stringValue.length - _groupedDigitsCount;
    while (true) {
      final startIndex = (splitIndex > 0)? splitIndex : 0;
      final substring = stringValue.substring(startIndex, splitIndex + _groupedDigitsCount);

      formattedValue = '$substring $formattedValue';

       if (splitIndex < 0) {
        break;
      }

      splitIndex -= _groupedDigitsCount;
    }

    return formattedValue.trim();
  }
}