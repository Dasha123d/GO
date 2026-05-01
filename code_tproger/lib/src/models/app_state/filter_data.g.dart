// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FilterData extends FilterData {
  @override
  final bool isForBeginner;

  factory _$FilterData([void Function(FilterDataBuilder)? updates]) =>
      (new FilterDataBuilder()..update(updates))._build();

  _$FilterData._({required this.isForBeginner}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isForBeginner, r'FilterData', 'isForBeginner');
  }

  @override
  FilterData rebuild(void Function(FilterDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FilterDataBuilder toBuilder() => new FilterDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FilterData && isForBeginner == other.isForBeginner;
  }

  @override
  int get hashCode {
    return $jf($jc(0, isForBeginner.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FilterData')
          ..add('isForBeginner', isForBeginner))
        .toString();
  }
}

class FilterDataBuilder implements Builder<FilterData, FilterDataBuilder> {
  _$FilterData? _$v;

  bool? _isForBeginner;
  bool? get isForBeginner => _$this._isForBeginner;
  set isForBeginner(bool? isForBeginner) =>
      _$this._isForBeginner = isForBeginner;

  FilterDataBuilder() {
    FilterData._setDefaults(this);
  }

  FilterDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isForBeginner = $v.isForBeginner;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FilterData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FilterData;
  }

  @override
  void update(void Function(FilterDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FilterData build() => _build();

  _$FilterData _build() {
    final _$result = _$v ??
        new _$FilterData._(
            isForBeginner: BuiltValueNullFieldError.checkNotNull(
                isForBeginner, r'FilterData', 'isForBeginner'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
