import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:tproger_mobile_app/src/models/actions/apply_filters_action.dart';
import 'package:tproger_mobile_app/src/models/actions/clear_filters_action.dart';
import 'package:tproger_mobile_app/src/models/actions/load_articles_action/load_articles_action.dart';
import 'package:tproger_mobile_app/src/models/actions/load_next_articles_action/load_next_articles_action.dart';
import 'package:tproger_mobile_app/src/models/actions/open_comment_link_action.dart';
import 'package:tproger_mobile_app/src/models/actions/open_link_action.dart';
import 'package:tproger_mobile_app/src/models/actions/sort_articles_action.dart';
import 'package:tproger_mobile_app/src/models/app_state/app_state.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/consts/app_common.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/view_models/article_list_page_view_model.dart';
import 'package:tproger_mobile_app/src/services/overlay_service.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_header/article_list_header_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_loader_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_widget.dart';
import 'package:tproger_mobile_app/src/widgets/common/page_widget.dart';

class ArticleListPageWidget extends PageWidget {
  static final _overlayService = GetIt.instance.get<OverlayService>();

  const ArticleListPageWidget({ super.key });

  @override
  Widget buildContent(BuildContext context) => StoreConnector<AppState, ArticleListPageViewModel>(
    distinct: true,
    converter: (store) => ArticleListPageViewModel(
      isArticlesFullLoaded: store.state.isArticlesFullLoaded,
      isAppLoaded: store.state.isAppLoaded,
      isFilterEnabled: store.state.isFilterEnabled,
      filterData: store.state.filterData,
      articlesSortType: store.state.articlesSortType,
      articles: store.state.articles.toList(),
      dispatch: store.dispatch,
    ),
    builder: (context, viewModel) {     
      if (!viewModel.isAppLoaded) {
        viewModel.dispatch(const LoadArticlesAction());

        return const ArticleListLoaderWidget();
      }

      return Column(
        children: [
          ArticleListHeaderWidget(
            articlesSortType: viewModel.articlesSortType,
            isFilterEnabled: viewModel.isFilterEnabled,
            onReadUsTelegramClick: () => _onReadUsTelegramClick(viewModel),
            onFilterClick: () => _onFilterClick(viewModel, context),
            onSelectSortType: (type) => _onSelectSortType(type, viewModel),
          ),
          Expanded(
            child: ArticleListWidget(
              isFullLoaded: viewModel.isArticlesFullLoaded,
              articles: viewModel.articles,
              onBookmarkClick: _onBookmarkClick,
              onCommentClick: (articleLink) => _onCommentClick(articleLink, viewModel),
              onTelegramLinkClick: () => _onTelegramLinkClick(viewModel),
              onArticleClick: (articleLink) => _onArticleClick(articleLink, viewModel),
              onRefresh: () => _onRefresh(viewModel),
              onLoadNextArticles: () => _onLoadNextArticles(viewModel),
            ),
          ),
        ],      
      );
    },
  );

  void _onReadUsTelegramClick(ArticleListPageViewModel viewModel) =>
    viewModel.dispatch(const OpenLinkAction(AppCommon.tprogerTelegramLink1));

  void _onLoadNextArticles(ArticleListPageViewModel viewModel) =>
    viewModel.dispatch(const LoadNextArticlesAction());

  Future<void> _onRefresh(ArticleListPageViewModel viewModel) async {
    viewModel.dispatch(const LoadArticlesAction());
  }

  void _onArticleClick(String articleLink, ArticleListPageViewModel viewModel) =>
    viewModel.dispatch(OpenLinkAction(articleLink));

  void _onBookmarkClick() {
    // ignore: avoid_print
    print('_onBookmarkClick');
  }

  void _onCommentClick(String articleLink, ArticleListPageViewModel viewModel) =>
    viewModel.dispatch(OpenCommentLinkAction(articleLink));

  void _onTelegramLinkClick(ArticleListPageViewModel viewModel) =>
    viewModel.dispatch(const OpenLinkAction(AppCommon.tprogerTelegramLink0));

  void _onSelectSortType(ArticlesSortType selectedType, ArticleListPageViewModel viewModel) =>
    viewModel.dispatch(SortArticlesAction(selectedType));

  void _onFilterClick(ArticleListPageViewModel viewModel, BuildContext context) =>
    _overlayService.showArticlesFilters(
      context: context,
      filterData: viewModel.filterData,
      onApplyClick: (filterData) => _onApplyClick(filterData, viewModel),
      onCleanOutClick: () => _onCleanOutClick(viewModel), 
      onCloseClick: _onCloseClick, 
    );
    
  Future<void> _onApplyClick(FilterData newFilterData, ArticleListPageViewModel viewModel) async {
    await _overlayService.hide();

    if (newFilterData != viewModel.filterData) {
      viewModel.dispatch(ApplyFiltersAction(
        newFilterData: newFilterData,
        oldFilterData: viewModel.filterData,
      )); 
    }
  }

  Future<void> _onCleanOutClick(ArticleListPageViewModel viewModel) async {
    await _overlayService.hide();

    if (viewModel.isFilterEnabled) {
      viewModel.dispatch(const ClearFiltersAction()); 
    }
  }

  void _onCloseClick() => _overlayService.hide();
}
