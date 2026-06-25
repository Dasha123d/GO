import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<ArticleModel> get articles;
  ArticlesSortType get articlesSortType;
  FilterData get filterData;
  bool get isArticlesFullLoaded;
  bool get isFilterEnabled;
  bool get isAppLoaded;
  int get articlesPageNumber;

  AppState._();
  factory AppState() = _$AppState;

  @BuiltValueHook(initializeBuilder: true)
  static void _setDefaults(AppStateBuilder b) => b
    ..articles.replace([])
    ..articlesSortType = ArticlesSortType.hot
    ..filterData.replace(FilterData.empty())
    ..isArticlesFullLoaded = false
    ..isFilterEnabled = false
    ..isAppLoaded = false
    ..articlesPageNumber = 1;
}