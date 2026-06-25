import 'package:equatable/equatable.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_image.dart';

class ParsedArticle extends Equatable {
  final String title;
  final String articleLink;
  final String description;
  final int id;
  final ArticleImage? image;
  final ArticleAuthor? author;

  @override
  List<Object?> get props => [title, articleLink, description, id, image, author];

  const ParsedArticle({
    required this.title,
    required this.articleLink,
    required this.description,
    required this.id,
    this.image,
    this.author,
  });
}
