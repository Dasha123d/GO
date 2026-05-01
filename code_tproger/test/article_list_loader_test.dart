@TestOn('vm')

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/article_reaction_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/article_reactions_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/article_bookmark_count_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/article_comment_count_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/article_view_count_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_response.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/services/article_list/article_list_loader.dart';
import 'package:tproger_mobile_app/src/services/article_list/article_list_parser.dart';
import 'package:tproger_mobile_app/src/services/http_service.dart';

import 'mocks/mocks.dart';

void main() {
  late ArticleListParser articleListParser;
  late HttpService httpService;
  late ArticleListLoader articleListLoader;

  setUpAll(() {
    registerFallbackValue(LoadArticlesCommentCountsRequestMock());
    registerFallbackValue(LoadArticlesBookmarkCountsRequestMock());
    registerFallbackValue(LoadArticlesViewCountsRequestMock());
    registerFallbackValue(LoadArticleReactionsRequestMock());
    registerFallbackValue(LoadNextArticlesRequestMock());
    registerFallbackValue(LoadInitialContentRequestMock());
  });

  setUp(() {
    articleListParser = ArticleListParserMock();
    httpService = HttpServiceMock();
    articleListLoader = ArticleListLoader(
      articleListParser,
      httpService,
    );
  });

  tearDown(() {
    reset(articleListParser);
    reset(httpService);
  });

  test('Load articles', () async {
    final parsedArticle1 = createParsedArticle(1);
    final parsedArticle2 = createParsedArticle(2);

    final expectedArticle1 = ArticleModel(
      title: parsedArticle1.title, 
      articleLink: parsedArticle1.articleLink, 
      description: parsedArticle1.description, 
      id: parsedArticle1.id, 
      author: parsedArticle1.author,
      image: parsedArticle1.image,
      bookmarkCount: 1, 
      viewCount: 1, 
      commentCount: 1, 
      reactions: const [
        ReactionData(
          reaction: Reaction.angry,
          count: 1,
        ),
      ],
    );
    final expectedArticle2 = ArticleModel(
      title: parsedArticle2.title, 
      articleLink: parsedArticle2.articleLink, 
      description: parsedArticle2.description, 
      id: parsedArticle2.id, 
      author: parsedArticle2.author,
      image: parsedArticle2.image,
      bookmarkCount: 2, 
      viewCount: 2, 
      commentCount: 2, 
      reactions: const [
        ReactionData(
          reaction: Reaction.angry,
          count: 1,
        ),
        ReactionData(
          reaction: Reaction.surprise,
          count: 2,
        ),
      ],
    );

    when(() => articleListParser.parse(any<String>())).thenReturn([
      parsedArticle1,
      parsedArticle2,
    ]);
    when(() => httpService.loadInitialContent(any<LoadInitialContentRequest>()))
      .thenAnswer((_) async => const LoadInitialContentResponse(''));
    when(() => httpService.loadArticlesCommentCounts(any<LoadArticlesCommentCountsRequest>()))
      .thenAnswer((_) async => const LoadArticlesCommentCountsResponse([
        ArticleCommentCountDto(articleId: 1, count: 1),
        ArticleCommentCountDto(articleId: 2, count: 2),
      ]));
    when(() => httpService.loadArticlesBookmarkCounts(any<LoadArticlesBookmarkCountsRequest>()))
      .thenAnswer((_) async => const LoadArticlesBookmarkCountsResponse([
        ArticleBookmarkCountDto(articleId: 1, count: 1),
        ArticleBookmarkCountDto(articleId: 2, count: 2),
      ]));
    when(() => httpService.loadArticlesViewCounts(any<LoadArticlesViewCountsRequest>()))
      .thenAnswer((_) async => const LoadArticlesViewCountsResponse([
        ArticleViewCountDto(articleId: 1, count: 1),
        ArticleViewCountDto(articleId: 2, count: 2),
      ]));
    when(() => httpService.loadArticleReactions(any<LoadArticleReactionsRequest>()))
      .thenAnswer((_) async => const LoadArticleReactionsResponse([
        ArticleReactionsDto(
          articleId: 1, 
          reactions: [
            ArticleReactionDto(
              count: 1,
              type: 1,
            ),
          ],
        ),
        ArticleReactionsDto(
          articleId: 2, 
          reactions: [
            ArticleReactionDto(
              count: 1,
              type: 1,
            ),
            ArticleReactionDto(
              count: 2,
              type: 2,
            ),
          ],
        ),
      ]));

    final articles = await articleListLoader.load(ArticlesSortType.hot);

    expect(expectedArticle1, equals(articles[0]));
    expect(expectedArticle2, equals(articles[1]));
  });

  test('Load next articles', () async {
    final parsedArticle = createParsedArticle(1);

    final expectedArticle = ArticleModel(
      title: parsedArticle.title, 
      articleLink: parsedArticle.articleLink, 
      description: parsedArticle.description, 
      id: parsedArticle.id, 
      author: parsedArticle.author,
      image: parsedArticle.image,
      bookmarkCount: 1, 
      viewCount: 1, 
      commentCount: 1, 
      reactions: const [
        ReactionData(
          reaction: Reaction.angry,
          count: 1,
        ),
      ],
    );

    when(() => articleListParser.parse(any<String>())).thenReturn([
      parsedArticle,
    ]);
    when(() => httpService.loadNextArticles(any<LoadNextArticlesRequest>()))
      .thenAnswer((_) async => const LoadNextArticlesResponse(''));
    when(() => httpService.loadArticlesCommentCounts(any<LoadArticlesCommentCountsRequest>()))
      .thenAnswer((_) async => const LoadArticlesCommentCountsResponse([
        ArticleCommentCountDto(articleId: 1, count: 1),
      ]));
    when(() => httpService.loadArticlesBookmarkCounts(any<LoadArticlesBookmarkCountsRequest>()))
      .thenAnswer((_) async => const LoadArticlesBookmarkCountsResponse([
        ArticleBookmarkCountDto(articleId: 1, count: 1),
      ]));
    when(() => httpService.loadArticlesViewCounts(any<LoadArticlesViewCountsRequest>()))
      .thenAnswer((_) async => const LoadArticlesViewCountsResponse([
        ArticleViewCountDto(articleId: 1, count: 1),
      ]));
    when(() => httpService.loadArticleReactions(any<LoadArticleReactionsRequest>()))
      .thenAnswer((_) async => const LoadArticleReactionsResponse([
        ArticleReactionsDto(
          articleId: 1, 
          reactions: [
            ArticleReactionDto(
              count: 1,
              type: 1,
            ),
          ],
        ),
      ]));

    final articles = await articleListLoader.loadNext(
      pageNumber: 2,
      sortType: ArticlesSortType.hot,
    );

    expect(expectedArticle, equals(articles.first));
  });
}