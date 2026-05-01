@TestOn('vm')

import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/exceptions/load_articles_list_exception.dart';
import 'package:tproger_mobile_app/src/models/exceptions/load_next_articles_exception.dart';
import 'package:tproger_mobile_app/src/services/article_list_loader.dart';
import 'package:tproger_mobile_app/src/services/article_list_service.dart';

import 'mocks/mocks.dart';

void main() {
  late ArticleListService articleListService;
  late Logger logger;
  late ArticleListLoader articleListLoader;

  setUpAll(() {
    registerFallbackValue(ExceptionMock());
    registerFallbackValue(StackTraceMock());
    registerFallbackValue(ArticlesSortType.hot);
  });

  setUp(() {
    articleListLoader = ArticleListLoaderMock();
    logger = LoggerMock();
    articleListService = ArticleListService(
      articleListLoader,
      logger,
    );
  });

  tearDown(() {
    reset(articleListLoader);
    reset(logger);
  });

  group('Getting articles', () {
    test('success', () async {
      final expectedArticle1 = createArticleModel(1);
      final expectedArticle2 = createArticleModel(2);

      when(() => articleListLoader.load(any<ArticlesSortType>())).thenAnswer((_) async => [
        expectedArticle1,
        expectedArticle2,
      ]);

      final articles = await articleListService.getArticles(ArticlesSortType.hot);

      expect(expectedArticle1, equals(articles[0]));
      expect(expectedArticle2, equals(articles[1]));

      verifyNever(() => logger.e(any<String>()));
    });

    test('failure', () async {
      when(() => articleListLoader.load(any<ArticlesSortType>())).thenThrow(Exception());

      try {
        await articleListService.getArticles(ArticlesSortType.hot);
        fail('Should be an LoadArticlesListException');
      } on LoadArticlesListException {
        verify(() => logger.e(any<String>(), any<Exception>(), any<StackTrace?>())).called(1);
      } on Exception {
        fail('Should be an LoadArticlesListException');
      }
    });
  });

  group('Getting next articles', () {
    test('success', () async {
      final expectedArticle = createArticleModel(1);

      when(() => articleListLoader.loadNext(
        pageNumber: any<int>(named: 'pageNumber'),
        sortType: any<ArticlesSortType>(named: 'sortType'),
      )).thenAnswer((_) async => [
        expectedArticle,
      ]);

      final articles = await articleListService.getNextArticles(
        pageNumber: 2,
        sortType: ArticlesSortType.hot,
      );

      expect(expectedArticle, equals(articles.first));

      verifyNever(() => logger.e(any<String>()));
    });

    test('failure', () async {
      when(() => articleListLoader.loadNext(
        pageNumber: any<int>(named: 'pageNumber'),
        sortType: any<ArticlesSortType>(named: 'sortType'),
      )).thenThrow(Exception());

      try {
        await articleListService.getNextArticles(
          pageNumber: 2,
          sortType: ArticlesSortType.hot,
        );
        fail('Should be an LoadNextArticlesException');
      } on LoadNextArticlesException {
        verify(() => logger.e(any<String>(), any<Exception>(), any<StackTrace?>())).called(1);
      } on Exception {
        fail('Should be an LoadNextArticlesException');
      }
    });
  });
}