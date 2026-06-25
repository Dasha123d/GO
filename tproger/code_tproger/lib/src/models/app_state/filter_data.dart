import 'package:built_value/built_value.dart';

part 'filter_data.g.dart';

abstract class FilterData implements Built<FilterData, FilterDataBuilder> {
  bool get isForBeginner;
  
  FilterData._();

  factory FilterData.empty() => _$FilterData();

  @BuiltValueHook(initializeBuilder: true)
  static void _setDefaults(FilterDataBuilder b) => b
    ..isForBeginner = false;
}