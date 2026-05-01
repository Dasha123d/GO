import 'dart:io';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/load_article_reactions_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/load_articles_bookmark_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/load_articles_comment_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/load_articles_view_counts_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_initial_content/load_initial_content_request.dart';
import 'package:tproger_mobile_app/src/models/api/load_next_articles/load_next_articles_request.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_icon_image.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';
import 'package:tproger_mobile_app/src/models/parsed_article/parsed_article.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/services/article_list_loader.dart';
import 'package:tproger_mobile_app/src/services/article_list_parser.dart';
import 'package:tproger_mobile_app/src/services/http_service.dart';

class ArticleListParserMock extends Mock implements ArticleListParser {}
class HttpServiceMock extends Mock implements HttpService {}
class ArticleListLoaderMock extends Mock implements ArticleListLoader {}
class LoggerMock extends Mock implements Logger {}
class LoadArticlesCommentCountsRequestMock extends Mock implements LoadArticlesCommentCountsRequest {}
class LoadArticlesBookmarkCountsRequestMock extends Mock implements LoadArticlesBookmarkCountsRequest {}
class LoadArticlesViewCountsRequestMock extends Mock implements LoadArticlesViewCountsRequest {}
class LoadArticleReactionsRequestMock extends Mock implements LoadArticleReactionsRequest {}
class LoadNextArticlesRequestMock extends Mock implements LoadNextArticlesRequest {}
class LoadInitialContentRequestMock extends Mock implements LoadInitialContentRequest {}
class ExceptionMock extends Mock implements Exception {}
class StackTraceMock extends Mock implements StackTrace {}

final _initialContentMockFileUri = Uri.file(
  // ignore: prefer_interpolation_to_compose_strings
  Directory.current.path +
  Platform.pathSeparator +
  'test' +
  Platform.pathSeparator +
  'mocks' +
  Platform.pathSeparator +
  'initial_content.html'
);

final _nextArticlesMockFileUri = Uri.file(
  // ignore: prefer_interpolation_to_compose_strings
  Directory.current.path +
  Platform.pathSeparator +
  'test' +
  Platform.pathSeparator +
  'mocks' +
  Platform.pathSeparator +
  'next_articles.html'
);

Future<String> getInitialContetMock() => File
  .fromUri(_initialContentMockFileUri)
  .readAsString();

Future<String> getNextArticlesMock() => File
  .fromUri(_nextArticlesMockFileUri)
  .readAsString();

ParsedArticle createParsedArticle(int id) => ParsedArticle(
  title: 'title$id', 
  description: 'description$id',
  id: id,
  articleLink: 'articleLink$id', 
  author: ArticleAuthor(
    name: 'name$id', 
    avatarLink: 'avatarLink$id',
  ),
  image: ArticleIconImage(
    link: 'link$id',
    backgroundColor: '#00000$id',
  ),
);

ArticleModel createArticleModel(int id) => ArticleModel(
  title: 'title$id', 
  description: 'description$id',
  id: id,
  articleLink: 'articleLink$id', 
  author: ArticleAuthor(
    name: 'name$id', 
    avatarLink: 'avatarLink$id',
  ),
  image: ArticleIconImage(
    link: 'link$id',
    backgroundColor: '#00000$id',
  ),
  bookmarkCount: id, 
  viewCount: id, 
  commentCount: id, 
  reactions: [
    ReactionData(
      reaction: Reaction.fromInt(id % Reaction.values.length),
      count: id,
    ),
  ],
);