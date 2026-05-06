// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final BuiltList<ArticleModel> articles;
  @override
  final ArticlesSortType articlesSortType;
  @override
  final FilterData filterData;
  @override
  final bool isArticlesFullLoaded;
  @override
  final bool isFilterEnabled;
  @override
  final bool isAppLoaded;
  @override
  final int articlesPageNumber;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (new AppStateBuilder()..update(updates))._build();

  _$AppState._(
      {required this.articles,
      required this.articlesSortType,
      required this.filterData,
      required this.isArticlesFullLoaded,
      required this.isFilterEnabled,
      required this.isAppLoaded,
      required this.articlesPageNumber})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(articles, r'AppState', 'articles');
    BuiltValueNullFieldError.checkNotNull(
        articlesSortType, r'AppState', 'articlesSortType');
    BuiltValueNullFieldError.checkNotNull(
        filterData, r'AppState', 'filterData');
    BuiltValueNullFieldError.checkNotNull(
        isArticlesFullLoaded, r'AppState', 'isArticlesFullLoaded');
    BuiltValueNullFieldError.checkNotNull(
        isFilterEnabled, r'AppState', 'isFilterEnabled');
    BuiltValueNullFieldError.checkNotNull(
        isAppLoaded, r'AppState', 'isAppLoaded');
    BuiltValueNullFieldError.checkNotNull(
        articlesPageNumber, r'AppState', 'articlesPageNumber');
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        articles == other.articles &&
        articlesSortType == other.articlesSortType &&
        filterData == other.filterData &&
        isArticlesFullLoaded == other.isArticlesFullLoaded &&
        isFilterEnabled == other.isFilterEnabled &&
        isAppLoaded == other.isAppLoaded &&
        articlesPageNumber == other.articlesPageNumber;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc(0, articles.hashCode),
                            articlesSortType.hashCode),
                        filterData.hashCode),
                    isArticlesFullLoaded.hashCode),
                isFilterEnabled.hashCode),
            isAppLoaded.hashCode),
        articlesPageNumber.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppState')
          ..add('articles', articles)
          ..add('articlesSortType', articlesSortType)
          ..add('filterData', filterData)
          ..add('isArticlesFullLoaded', isArticlesFullLoaded)
          ..add('isFilterEnabled', isFilterEnabled)
          ..add('isAppLoaded', isAppLoaded)
          ..add('articlesPageNumber', articlesPageNumber))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  ListBuilder<ArticleModel>? _articles;
  ListBuilder<ArticleModel> get articles =>
      _$this._articles ??= new ListBuilder<ArticleModel>();
  set articles(ListBuilder<ArticleModel>? articles) =>
      _$this._articles = articles;

  ArticlesSortType? _articlesSortType;
  ArticlesSortType? get articlesSortType => _$this._articlesSortType;
  set articlesSortType(ArticlesSortType? articlesSortType) =>
      _$this._articlesSortType = articlesSortType;

  FilterDataBuilder? _filterData;
  FilterDataBuilder get filterData =>
      _$this._filterData ??= new FilterDataBuilder();
  set filterData(FilterDataBuilder? filterData) =>
      _$this._filterData = filterData;

  bool? _isArticlesFullLoaded;
  bool? get isArticlesFullLoaded => _$this._isArticlesFullLoaded;
  set isArticlesFullLoaded(bool? isArticlesFullLoaded) =>
      _$this._isArticlesFullLoaded = isArticlesFullLoaded;

  bool? _isFilterEnabled;
  bool? get isFilterEnabled => _$this._isFilterEnabled;
  set isFilterEnabled(bool? isFilterEnabled) =>
      _$this._isFilterEnabled = isFilterEnabled;

  bool? _isAppLoaded;
  bool? get isAppLoaded => _$this._isAppLoaded;
  set isAppLoaded(bool? isAppLoaded) => _$this._isAppLoaded = isAppLoaded;

  int? _articlesPageNumber;
  int? get articlesPageNumber => _$this._articlesPageNumber;
  set articlesPageNumber(int? articlesPageNumber) =>
      _$this._articlesPageNumber = articlesPageNumber;

  AppStateBuilder() {
    AppState._setDefaults(this);
  }

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _articles = $v.articles.toBuilder();
      _articlesSortType = $v.articlesSortType;
      _filterData = $v.filterData.toBuilder();
      _isArticlesFullLoaded = $v.isArticlesFullLoaded;
      _isFilterEnabled = $v.isFilterEnabled;
      _isAppLoaded = $v.isAppLoaded;
      _articlesPageNumber = $v.articlesPageNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              articles: articles.build(),
              articlesSortType: BuiltValueNullFieldError.checkNotNull(
                  articlesSortType, r'AppState', 'articlesSortType'),
              filterData: filterData.build(),
              isArticlesFullLoaded: BuiltValueNullFieldError.checkNotNull(
                  isArticlesFullLoaded, r'AppState', 'isArticlesFullLoaded'),
              isFilterEnabled: BuiltValueNullFieldError.checkNotNull(
                  isFilterEnabled, r'AppState', 'isFilterEnabled'),
              isAppLoaded: BuiltValueNullFieldError.checkNotNull(
                  isAppLoaded, r'AppState', 'isAppLoaded'),
              articlesPageNumber: BuiltValueNullFieldError.checkNotNull(
                  articlesPageNumber, r'AppState', 'articlesPageNumber'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'articles';
        articles.build();

        _$failedField = 'filterData';
        filterData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
