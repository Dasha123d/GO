import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_request.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_response.dart';
import 'package:tproger_mobile_app/src/models/parsed_article/addition_data.dart';
import 'package:tproger_mobile_app/src/models/parsed_article/parsed_article.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';
import 'package:tproger_mobile_app/src/services/article_list/article_list_parser.dart';
import 'package:tproger_mobile_app/src/services/http_service.dart';

@singleton
class ArticleListLoader {
  final ArticleListParser _articleListParser;
  final HttpService _httpService;

  ArticleListLoader(
    this._articleListParser,
    this._httpService,
  );

  Future<List<ArticleModel>> load(
    ArticlesSortType sortType,
    FilterData filterData,
    bool isFilterEnabled,
  ) async {
    final appliedFilterData = isFilterEnabled
      ? filterData
      : FilterData.empty();

    final response = await _httpService.loadInitialContent(LoadInitialContentRequest(
      sortType: sortType,
      isForBeginner: appliedFilterData.isForBeginner,
    ));

    return _parseArticles(response.html);
  }

  Future<List<ArticleModel>> loadNext(
    int pageNumber,
    ArticlesSortType sortType,
    FilterData filterData,
    bool isFilterEnabled,
  ) async {
    final appliedFilterData = isFilterEnabled
      ? filterData
      : FilterData.empty();

    final response = await _httpService.loadNextArticles(LoadNextArticlesRequest(
      pageNumber: pageNumber,
      sortType: sortType,
      isForBeginner: appliedFilterData.isForBeginner,
    ));
    
    return _parseArticles(response.html);
  }

  Future<List<ArticleModel>> _parseArticles(String html) async {
    final parsedArticles = _articleListParser.parse(html);
    if (parsedArticles.isEmpty) {
      return [];
    }

    final data = await _loadAdditionalData(parsedArticles);
    return _getArticleModels(data);
  }

  Future<List<AdditionalData>> _loadAdditionalData(List<ParsedArticle> articles) async {
    final encodedIds = _encodeIds(articles);

    final responses = await Future.wait([
      _httpService.loadArticlesCommentCounts(LoadArticlesCommentCountsRequest(encodedIds)),
      _httpService.loadArticlesBookmarkCounts(LoadArticlesBookmarkCountsRequest(encodedIds)),
      _httpService.loadArticlesViewCounts(LoadArticlesViewCountsRequest(encodedIds)),
      _httpService.loadArticleReactions(LoadArticleReactionsRequest(encodedIds)),
    ]);

    final loadArticlesCommentCountsResponse = responses[0] as LoadArticlesCommentCountsResponse;
    final loadArticlesBookmarkCountsResponse = responses[1] as LoadArticlesBookmarkCountsResponse;
    final loadArticlesViewCountsResponse = responses[2] as LoadArticlesViewCountsResponse;
    final loadArticleReactionsResponse = responses[3] as LoadArticleReactionsResponse;

    final idsToCommentCounts = _getArticleIdsToCommentCounts(loadArticlesCommentCountsResponse);
    final idsToBookmarkCounts = _getArticleIdsToBookmarkCounts(loadArticlesBookmarkCountsResponse);
    final idsToViewCounts = _getArticleIdsToViewCounts(loadArticlesViewCountsResponse);
    final idsToReactions = _getArticleIdsToReactions(loadArticleReactionsResponse);

    final additionalData = articles
      .map((article) => AdditionalData(
        sourceArticle: article,
        commentCount: idsToCommentCounts[article.id] ?? 0,
        bookmarkCount: idsToBookmarkCounts[article.id] ?? 0,
        viewCount: idsToViewCounts[article.id] ?? 0,
        reactions: idsToReactions[article.id] ?? [],
      ))
      .toList();

    return additionalData;
  }

  String _encodeIds(List<ParsedArticle> articles) =>
    articles.map((article) => article.id).join(',');

  MapIdToCount _getArticleIdsToCommentCounts(LoadArticlesCommentCountsResponse response) =>
    {for (final count in response.counts) count.articleId: count.count};

  MapIdToCount _getArticleIdsToBookmarkCounts(LoadArticlesBookmarkCountsResponse response) =>
    {for (final count in response.counts) count.articleId: count.count};

  MapIdToCount _getArticleIdsToViewCounts(LoadArticlesViewCountsResponse response) =>
    {for (final count in response.counts) count.articleId: count.count};

  MapIdToReactions _getArticleIdsToReactions(LoadArticleReactionsResponse response) {
    final MapIdToReactions idsToReactions = {};

    for (final articleReaction in response.articleReactions) {
      final reactions = articleReaction.reactions;
      final articleId = articleReaction.articleId;

      final reactionToCount = [
        for (var i = 0; i < reactions.length; i++) ReactionData(
          reaction: Reaction.fromInt(reactions[i].type),
          count: reactions[i].count,
        )
      ];

      idsToReactions[articleId] = reactionToCount;
    }

    return idsToReactions;
  }

  List<ArticleModel> _getArticleModels(List<AdditionalData> data) =>
    data.map(_getArticleModel).toList();

  ArticleModel _getArticleModel(AdditionalData data) => ArticleModel(
    id: data.sourceArticle.id,
    articleLink: data.sourceArticle.articleLink,
    title: data.sourceArticle.title,
    description: data.sourceArticle.description,
    author: data.sourceArticle.author,
    image: data.sourceArticle.image,
    bookmarkCount: data.bookmarkCount,
    viewCount: data.viewCount,
    commentCount: data.commentCount,
    reactions: data.reactions,
  );
}
