import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_image.dart';
import 'package:tproger_mobile_app/src/models/enums/article_list_selector.dart';
import 'package:tproger_mobile_app/src/models/enums/base_url.dart';
import 'package:tproger_mobile_app/src/models/parsed_article/parsed_article.dart';

@singleton
class ArticleListParser {
  static final backgroundColorPattern = RegExp(r'#[0-9a-f]{3,6}', caseSensitive: false);

  List<ParsedArticle> parse(String html) {
    final document = html_parser.parse(html);
    return _parseArticles(document);
  }

  List<ParsedArticle> _parseArticles(Document document) {
    final articleElements = document.querySelectorAll(ArticleListSelector.article.value);
    return articleElements.map(_parseArticle).toList();
  }

  ParsedArticle _parseArticle(Element articleElement) {
    final titleElement = _getTitleElement(articleElement);
    final authorElement = _getAuthorElement(articleElement);

    final imageLink = _parseImage(articleElement);
    final imageBackgroundColor = _parseImageBackgroundColor(articleElement);
    final image = (imageLink == null)? null : ArticleImage.from(
      link: imageLink,
      backgroundColor: imageBackgroundColor,
    );

    final authorAvatarLink = _parseAuthorAvatarLink(authorElement);
    final authorName = _parseAuthorName(authorElement);
    final author = (authorName == null)? null : ArticleAuthor(
      avatarLink: authorAvatarLink!,
      name: authorName,
    );

    return ParsedArticle(
      title: _parseTitle(titleElement),
      articleLink: _parseLink(titleElement),
      description: _parseDescription(articleElement),
      id: _parseId(articleElement),
      author: author,
      image: image,
    );
  }

  String _parseTitle(Element titleElement) => titleElement.text.trim();

  String _parseLink(Element titleElement) => titleElement.attributes['href']!;

  String? _parseImage(Element articleElement) {
    var imageElement = _getIconImageElement(articleElement);
    if (imageElement != null) {
      final link = _getImageLink(imageElement);
      if (link != null) {
        return link;
      }
    }

    imageElement = _getBackgroundImageElement(articleElement);
    if (imageElement != null) {
      final link = _getImageLink(imageElement);
      if (link != null) {
        return link;
      }
    }

    return null;
  }

  String? _parseImageBackgroundColor(Element articleElement) {
    final backgroundColorElement = _getImageBackgroundColorElement(articleElement);
    if (backgroundColorElement == null) {
      return null;
    }

    return _getBackgroundColor(backgroundColorElement);
  }

  String _parseDescription(Element articleElement) {
    final descriptionElement = _getDescriptionElement(articleElement);
    return _removeSpaces(descriptionElement.text);
  }

  int _parseId(Element articleElement) {
    final dataPost = articleElement.attributes['data-post']!;
    return int.parse(dataPost);
  }

  String? _parseAuthorAvatarLink(Element? authorElement) {
    if (authorElement == null) {
      return null;
    }

    final authorAvatarElement = authorElement.querySelector('img');
    if (authorAvatarElement == null) {
      return null;
    }

    final src = authorAvatarElement.attributes['src'];
    if (src != null && _isLinkToImage(src)) {
      if (_isLinkHasHost(src)) {
        return src;
      }

      return _addHostToLink(src);
    }

    final dataSrc = authorAvatarElement.attributes['data-src']!;
    if (_isLinkHasHost(dataSrc)) {
      return dataSrc;
    }

    return _addHostToLink(dataSrc);
  }

  String? _parseAuthorName(Element? authorElement) {
    if (authorElement == null) {
      return null;
    }

    var authorNameElement = _getAuthorUserNameElement(authorElement);
    if (authorNameElement != null) {
      return authorNameElement.text.trim();
    }

    authorNameElement = _getAuthorCompanyNameElement(authorElement);
    if (authorNameElement != null) {
      return authorNameElement.text.trim();
    }
    
    return null;
  }

  Element _getTitleElement(Element articleElement) =>
    articleElement.querySelector(ArticleListSelector.title.value)!;

  Element? _getAuthorElement(Element articleElement) =>
    articleElement.querySelector(ArticleListSelector.authorImage.value);

  Element? _getIconImageElement(Element articleElement) =>
    articleElement.querySelector(ArticleListSelector.imageIcon.value);

  Element? _getBackgroundImageElement(Element articleElement) =>
    articleElement.querySelector(ArticleListSelector.imageBackground.value);

  Element? _getImageBackgroundColorElement(Element articleElement) =>
    articleElement.querySelector(ArticleListSelector.imageBackgroundColor.value);

  String? _getImageLink(Element imageElement) {
    final src = imageElement.attributes['src'];
    if (src != null && _isLinkToImage(src)) {
      return src;
    }

    final dataSrc = imageElement.attributes['data-src'];
    return dataSrc;
  }

  String _getBackgroundColor(Element backgroundColorElement) {
    final style = backgroundColorElement.attributes['style']!;
    final match = backgroundColorPattern.firstMatch(style)!;
    final color = match.group(0)!;
    
    return color;
  }

  Element _getDescriptionElement(Element articleElement) =>
    articleElement.querySelector(ArticleListSelector.description.value)!;

  Element? _getAuthorUserNameElement(Element authorElement) =>
    authorElement.querySelector(ArticleListSelector.authorUserName.value);
  
  Element? _getAuthorCompanyNameElement(Element authorElement) =>
    authorElement.querySelector(ArticleListSelector.authorCompanyName.value);

  String _removeSpaces(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ');

  bool _isLinkHasHost(String link) => link.contains(BaseUrl.host.value);

  bool _isLinkToImage(String link) => link.endsWith('.png') || 
    link.endsWith('.jpg') ||
    link.endsWith('.jpeg');

  String _addHostToLink(String link) => 'https://${BaseUrl.host}$link';
}
