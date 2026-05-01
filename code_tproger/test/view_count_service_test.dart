@TestOn('vm')

import 'package:test/test.dart';
import 'package:tproger_mobile_app/src/services/view_count_service.dart';

void main() {
  final viewCountService = ViewCountService();

  test('Format count of views', () async {
    expect(viewCountService.format(1), equals('1'));
    expect(viewCountService.format(12), equals('12'));
    expect(viewCountService.format(123), equals('123'));
    expect(viewCountService.format(1234), equals('1234'));
    expect(viewCountService.format(12345), equals('12 345'));
    expect(viewCountService.format(123456), equals('123 456'));
    expect(viewCountService.format(1234567), equals('1 234 567'));
    expect(viewCountService.format(12345678), equals('12 345 678'));
    expect(viewCountService.format(123456789), equals('123 456 789'));
    expect(viewCountService.format(1234567890), equals('1 234 567 890'));
  });
}