import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/exceptions/load_next_articles_exception.dart';
import 'package:tproger_mobile_app/src/services/article_list/article_list_loader.dart';
import 'package:tproger_mobile_app/src/models/exceptions/load_articles_list_exception.dart';

@singleton
class ArticleListService {
  final ArticleListLoader _articleListLoader;

  ArticleListService(this._articleListLoader);

  Future<List<ArticleModel>> getArticles(
    ArticlesSortType sortType,
    FilterData filterData,
    bool isFilterEnabled,
  ) async {
    try {
      return await _articleListLoader.load(sortType, filterData, isFilterEnabled);
    } on Exception {
      throw const LoadArticlesListException();
    }
  }

  Future<List<ArticleModel>> getNextArticles(
    int pageNumber,
    ArticlesSortType sortType,
    FilterData filterData,
    bool isFilterEnabled,
  ) async {
    try {
      return await _articleListLoader.loadNext(pageNumber, sortType, filterData, isFilterEnabled);
    } on Exception {
      throw const LoadNextArticlesException();
    }
  }
}