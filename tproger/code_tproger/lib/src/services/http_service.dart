import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_response.dart';
import 'package:tproger_mobile_app/src/models/enums/api_url.dart';
import 'package:tproger_mobile_app/src/models/enums/method.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_response.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_response.dart';

@singleton
class HttpService {
  final Dio _dio;

  HttpService(this._dio);

  Future<LoadInitialContentResponse> loadInitialContent(LoadInitialContentRequest request) async {
    final response = await _request(Method.get, ApiUrl.initial, request.toJson());
    return LoadInitialContentResponse.fromJson(response);
  }

  Future<LoadNextArticlesResponse> loadNextArticles(LoadNextArticlesRequest request) async {
    final response = await _request(Method.get, ApiUrl.loadNextArticles, request.toJson());
    return LoadNextArticlesResponse.fromJson(response);
  }

  Future<LoadArticlesCommentCountsResponse> loadArticlesCommentCounts(LoadArticlesCommentCountsRequest request) async {
    final response = await _request(Method.get, ApiUrl.articlesCommentCounts, request.toJson());
    return LoadArticlesCommentCountsResponse.fromJson(response);
  }

  Future<LoadArticlesBookmarkCountsResponse> loadArticlesBookmarkCounts(LoadArticlesBookmarkCountsRequest request) async {
    final response = await _request(Method.get, ApiUrl.articlesBookmarkCounts, request.toJson());
    return LoadArticlesBookmarkCountsResponse.fromJson(response);
  }

  Future<LoadArticlesViewCountsResponse> loadArticlesViewCounts(LoadArticlesViewCountsRequest request) async {
    final response = await _request(Method.get, ApiUrl.articlesViewCounts, request.toJson());
    return LoadArticlesViewCountsResponse.fromJson(response);
  }

  Future<LoadArticleReactionsResponse> loadArticleReactions(LoadArticleReactionsRequest request) async {
    final response = await _request(Method.get, ApiUrl.articleReactions, request.toJson());
    return LoadArticleReactionsResponse.fromJson(response);
  }

  Future<dynamic> _request(
    Method method,
    ApiUrl url,
    Map<String, dynamic> params,
  ) async {
    Response response;

    switch (method) {
      case Method.get:
        response = await _dio.get(url.value, queryParameters: params);
        break;
      default:
        throw UnimplementedError('Another http methods are not implemented');
    }

    return response.data;
  }
}
