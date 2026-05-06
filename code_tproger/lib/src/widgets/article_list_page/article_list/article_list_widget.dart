import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_end/article_list_end_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_loader_widget.dart';

class ArticleListWidget extends StatelessWidget {
  final List<ArticleModel> articles;
  final bool isFullLoaded;
  final FutureVoidFunction onRefresh;
  final VoidFunction onBookmarkClick;
  final VoidFunction onTelegramLinkClick;
  final VoidFunction onLoadNextArticles;
  final VoidFunctionString onCommentClick;
  final VoidFunctionString onArticleClick;

  const ArticleListWidget({
    required this.articles,
    required this.isFullLoaded,
    required this.onRefresh,
    required this.onBookmarkClick,
    required this.onCommentClick,
    required this.onArticleClick,
    required this.onTelegramLinkClick,
    required this.onLoadNextArticles,
    super.key,
  });

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    color: AppTheme.of(context).loaderColor,
    backgroundColor: AppTheme.of(context).mainBackgroundColor,
    onRefresh: onRefresh,
    child: ListView.separated(
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      itemCount: articles.length + 1,
      itemBuilder: _itemBuilder,
      separatorBuilder: _separatorBuilder,
    ),
  );

  Widget _itemBuilder(BuildContext context, int index) {
    final isArticle = index < articles.length;
    final isLastArticle = index == articles.length - 1;
    final isLastWidget = index == articles.length;

    if (!isFullLoaded && isLastArticle) {
      onLoadNextArticles();
    } 

    late final Widget widget;
    
    if (isArticle) {
      widget = ArticleWidget(
        key: ValueKey(articles[index].id),
        article: articles[index],
        onContentClick: () => onArticleClick(articles[index].articleLink),
        onCommentClick: () => onCommentClick(articles[index].articleLink),
        onBookmarkClick: onBookmarkClick,
      );
    } else if (isFullLoaded && isLastWidget) {
      widget = ArticleListEndWidget(
        onTelegramLinkClick: onTelegramLinkClick,
      );
    } else {
      widget = articles.isEmpty
        ? const Padding(
            padding: EdgeInsets.only(top: AppSize.articleListLastItemSeparatorSize),
            child: ArticleListLoaderWidget()
          )
        : const ArticleListLoaderWidget();
    }

    return widget;
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    final isLastArticle = index == articles.length - 1;
    final height = isLastArticle
      ? AppSize.articleListLastItemSeparatorSize
      : AppSize.articleListArticleSeparatorSize;

    return SizedBox(height: height);
  }  
}