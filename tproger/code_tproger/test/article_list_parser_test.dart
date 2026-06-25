@TestOn('vm')

import 'package:test/test.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_icon_image.dart';
import 'package:tproger_mobile_app/src/models/parsed_article/parsed_article.dart';
import 'package:tproger_mobile_app/src/services/article_list_parser.dart';

import 'mocks/mocks.dart';

void main() {
  final articleListParser = ArticleListParser();

  test('Parse html to extract articles', () async {
    const expectedArticle1 = ParsedArticle(
      title: 'Технология AR: как работает и на чём создать проект', 
      articleLink: 'https://tproger.ru/articles/tehnologija-ar-kak-rabotaet-i-na-chjom-sozdat-proekt/', 
      description: 'Технология дополненной реальности позволяет добавлять цифровые элементы в «живую» картинку. Рассказываем, как разработать простой AR-проект.', 
      id: 232720,
      author: ArticleAuthor(
        name: 'МТС', 
        avatarLink: 'https://media.tproger.ru/uploads/2022/01/mts.png',
      ),
      image: ArticleIconImage(
        link: 'https://media.tproger.ru/uploads/2022/11/mobile_icon-cover-icon-original.png',
        backgroundColor: '#5ec4cd',
      ),
    );
    const expectedArticle2 = ParsedArticle(
      title: 'Распределение памяти в Python: сколько и в каких случаях занимают типы данных', 
      articleLink: 'https://tproger.ru/articles/raspredelenie-pamjati-v-python-skolko-i-v-kakih-sluchajah-zanimajut-tipy-dannyh/', 
      description: 'Как устроено выделение памяти под объекты в Python, как работает очистка памяти и в чём разница в памяти на примере типов list, dict и tuple.', 
      id: 232784,
      author: ArticleAuthor(
        name: 'Илья Латышев', 
        avatarLink: 'https://tproger.ru/wp-content/themes/gecko/images/default-avatar.png',
      ),
      image: ArticleIconImage(
        link: 'https://media.tproger.ru/uploads/2022/11/5879242_animal_python_reptile_snake_icon-cover-icon-1-original.png',
        backgroundColor: '#f0ffe8',
      ),
    );
    const expectedArticle3 = ParsedArticle(
      title: 'Пишем программу для тестирования на С++', 
      articleLink: 'https://tproger.ru/articles/pishem-programmu-dlja-testirovanija-s/', 
      description: 'Рассказываем, как написать программу тестирования для проверки работы или знаний человека. В качестве языка программирования используем С++.', 
      id: 232698,
      author: ArticleAuthor(
        name: 'Искусство разработки игр', 
        avatarLink: 'https://tproger.ru/wp-content/themes/gecko/images/default-avatar.png',
      ),
      image: ArticleIconImage(
        link: 'https://media.tproger.ru/uploads/2022/11/5318405_c_extension_file_format_programming_icon-cover-icon-1-original.png',
        backgroundColor: '#8690fa',
      ),
    );

    final initialContetMock = await getInitialContetMock();

    final articles = articleListParser.parse(initialContetMock);

    expect(expectedArticle1, equals(articles[0]));
    expect(expectedArticle2, equals(articles[1]));
    expect(expectedArticle3, equals(articles[2]));
  });

  test('Parse html to extract articles', () async {
    const expectedArticle = ParsedArticle(
      title: '5 полезных книг по железу', 
      articleLink: 'https://tproger.ru/digest/5-poleznyh-knig-po-zhelezu/', 
      description: 'Составили подборку из 5 книг про компьютеры, которые помогут разобраться в архитектуре ЭВМ и понять, как работает все железное.', 
      id: 233185,
      author: ArticleAuthor(
        name: 'Daria R', 
        avatarLink: 'https://tproger.ru/wp-content/themes/gecko/images/default-avatar.png',
      ),
      image: ArticleIconImage(
        link: 'https://media.tproger.ru/uploads/2022/11/7063320_motherboard_hardware_computer_chips_icon-cover-icon-original.png',
        backgroundColor: '#8cc0f4',
      ),
    );

    final nextArticlesMock = await getNextArticlesMock();

    final articles = articleListParser.parse(nextArticlesMock);

    expect(expectedArticle, equals(articles.first));
  });
}