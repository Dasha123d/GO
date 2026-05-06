import 'package:injectable/injectable.dart';
import 'package:redux/redux.dart';
import 'package:tproger_mobile_app/src/models/actions/apply_filters_action.dart';
import 'package:tproger_mobile_app/src/models/actions/clear_filters_action.dart';
import 'package:tproger_mobile_app/src/models/actions/load_articles_action/load_articles_action.dart';
import 'package:tproger_mobile_app/src/models/actions/load_articles_action/load_articles_success_action.dart';
import 'package:tproger_mobile_app/src/models/actions/load_next_articles_action/load_next_articles_success_action.dart';
import 'package:tproger_mobile_app/src/models/actions/sort_articles_action.dart';
import 'package:tproger_mobile_app/src/models/app_state/app_state.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';

@singleton
class ReducerService {
  Reducer<AppState> get reducer => combineReducers<AppState>([
    TypedReducer(_loadArticles),
    TypedReducer(_loadArticlesSuccess),
    TypedReducer(_loadNextArticlesSuccess),
    TypedReducer(_sortArticles),
    TypedReducer(_applyFilters),
    TypedReducer(_clearFilters),
  ]);

  AppState _loadArticles(AppState state, LoadArticlesAction action) => state.rebuild((b) => b
    ..articles.replace([])
    ..isArticlesFullLoaded = false
    ..articlesPageNumber = 1
  );

  AppState _loadArticlesSuccess(AppState state, LoadArticlesSuccessAction action) => 
    state.rebuild((b) => b
      ..articles.replace(action.articles)
      ..isArticlesFullLoaded = action.articles.isEmpty
      ..isAppLoaded = true
    );

  AppState _loadNextArticlesSuccess(AppState state, LoadNextArticlesSuccessAction action) => 
    state.rebuild((b) => b
      ..articles.addAll(action.articles)
      ..articlesPageNumber = action.pageNumber
      ..isArticlesFullLoaded = action.articles.isEmpty
    );

  AppState _sortArticles(AppState state, SortArticlesAction action) => 
    state.rebuild((b) => b
      ..articlesSortType = action.sortType
    );

  AppState _applyFilters(AppState state, ApplyFiltersAction action) =>
    state.rebuild((b) => b
      ..isFilterEnabled = action.newFilterData != FilterData.empty()
      ..filterData.replace(action.newFilterData)
    );

  AppState _clearFilters(AppState state, ClearFiltersAction action) => 
    state.rebuild((b) => b
      ..isFilterEnabled = false
      ..filterData.replace(FilterData.empty())
    );
}