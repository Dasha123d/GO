@TestOn('vm')

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/article_reaction_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/article_reactions_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/article_bookmark_count_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/article_comment_count_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/article_view_count_dto.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_response.dart';
import 'package:tproger_mobile_app/src/models/enums/api_url.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_response.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/services/di_configuration/register_module.dart';
import 'package:tproger_mobile_app/src/services/http_service.dart';

import 'mocks/mocks.dart';

void main() {
  final dio = Dio(dioBaseOptions);
  final dioAdapter = DioAdapter(dio: dio);
  final httpService = HttpService(dio);

  test('Load initial content', () async {
    final initialContetMock = await getInitialContetMock();
    final expectedResponse = LoadInitialContentResponse(initialContetMock);

    dioAdapter.onGet(
      ApiUrl.initial.value, 
      (server) => server.reply(
        200,
        initialContetMock,
      ),
      queryParameters: {
        'sort': 'hot',
      },
    );

    final response = await httpService.loadInitialContent(const LoadInitialContentRequest(ArticlesSortType.hot));

    expect(response, equals(expectedResponse));
  });

  test('Load next articles', () async {
    final nextArticlesMock = await getNextArticlesMock();
    final expectedResponse = LoadNextArticlesResponse(nextArticlesMock);

    dioAdapter.onGet(
      ApiUrl.loadNextArticles.value, 
      (server) => server.reply(
        200,
        nextArticlesMock,
      ),
      queryParameters: {
        'page': 2,
        'action': 'infinite-scroll',
        'sort': 'hot',
      },
    );

    final response = await httpService.loadNextArticles(const LoadNextArticlesRequest(
      pageNumber: 2,
      sortType: ArticlesSortType.hot,
    ));

    expect(response, equals(expectedResponse));
  });

  test('Load comment counts of articles', () async {
    const expectedResponse = LoadArticlesCommentCountsResponse([
      ArticleCommentCountDto(articleId: 1, count: 1),
      ArticleCommentCountDto(articleId: 2, count: 2),
    ]);

    dioAdapter.onGet(
      ApiUrl.articlesCommentCounts.value, 
      (server) => server.reply(
        200,
        [
          {
            'post': 1,
            'count': 1,
          },
          {
            'post': 2,
            'count': 2,
          },
        ],
      ),
      queryParameters: {
        'ids': '1, 2',
      },
    );

    final response = await httpService.loadArticlesCommentCounts(
      const LoadArticlesCommentCountsRequest('1, 2'),
    );

    expect(response, equals(expectedResponse));
  });

  test('Load bookmark counts of articles', () async {
    const expectedResponse = LoadArticlesBookmarkCountsResponse([
      ArticleBookmarkCountDto(articleId: 1, count: 1),
      ArticleBookmarkCountDto(articleId: 2, count: 2),
    ]);

    dioAdapter.onGet(
      ApiUrl.articlesBookmarkCounts.value, 
      (server) => server.reply(
        200,
        [
          {
            'post': 1,
            'count': 1,
          },
          {
            'post': 2,
            'count': 2,
          },
        ],
      ),
      queryParameters: {
        'ids': '1, 2',
      },
    );

    final response = await httpService.loadArticlesBookmarkCounts(
      const LoadArticlesBookmarkCountsRequest('1, 2'),
    );

    expect(response, equals(expectedResponse));
  });

  test('Load view counts of articles', () async {
    const expectedResponse = LoadArticlesViewCountsResponse([
      ArticleViewCountDto(articleId: 1, count: 1),
      ArticleViewCountDto(articleId: 2, count: 2),
    ]);

    dioAdapter.onGet(
      ApiUrl.articlesViewCounts.value, 
      (server) => server.reply(
        200,
        [
          {
            'post': 1,
            'count': 1,
          },
          {
            'post': 2,
            'count': 2,
          },
        ],
      ),
      queryParameters: {
        'ids': '1, 2',
      },
    );

    final response = await httpService.loadArticlesViewCounts(
      const LoadArticlesViewCountsRequest('1, 2'),
    );

    expect(response, equals(expectedResponse));
  });

  test('Load reactions of articles', () async {
    const expectedResponse = LoadArticleReactionsResponse([
      ArticleReactionsDto(
        articleId: 1, 
        reactions: [
          ArticleReactionDto(type: 1, count: 1),
        ],
      ),
      ArticleReactionsDto(
        articleId: 2, 
        reactions: [
          ArticleReactionDto(type: 1, count: 1),
          ArticleReactionDto(type: 2, count: 2),
        ],
      ),
    ]);

    dioAdapter.onGet(
      ApiUrl.articleReactions.value, 
      (server) => server.reply(
        200,
        [
          {
            'post': 1,
            'reactions': [
              {
                'reaction': 1,
                'count': 1,
              },
            ],
          },
          {
            'post': 2,
            'reactions': [
              {
                'reaction': 1,
                'count': 1,
              },
              {
                'reaction': 2,
                'count': 2,
              },
            ],
          },
        ],
      ),
      queryParameters: {
        'ids': '1, 2',
      },
    );

    final response = await httpService.loadArticleReactions(
      const LoadArticleReactionsRequest('1, 2'),
    );

    expect(response, equals(expectedResponse));
  });
}