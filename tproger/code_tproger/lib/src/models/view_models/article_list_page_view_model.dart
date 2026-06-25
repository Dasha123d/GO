import 'package:equatable/equatable.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class ArticleListPageViewModel extends Equatable {
  final bool isArticlesFullLoaded;
  final bool isAppLoaded;
  final bool isFilterEnabled;
  final FilterData filterData;
  final ArticlesSortType articlesSortType;
  final List<ArticleModel> articles;
  final DynamicFunctionDynamic dispatch;

  @override
  List<Object> get props => [
    isArticlesFullLoaded,
    isAppLoaded,
    isFilterEnabled,
    // filterData, Should not rebuild when the field changed
    articlesSortType,
    articles,
    dispatch,
  ];

  const ArticleListPageViewModel({
    required this.isArticlesFullLoaded,
    required this.isAppLoaded,
    required this.isFilterEnabled,
    required this.filterData,
    required this.articlesSortType,
    required this.articles,
    required this.dispatch,
  });
}