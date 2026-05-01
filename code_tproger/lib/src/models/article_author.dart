import 'package:equatable/equatable.dart';

class ArticleAuthor extends Equatable {
  final String name;
  final String avatarLink;

  @override
  List<Object> get props => [name, avatarLink];

  const ArticleAuthor({
    required this.name,
    required this.avatarLink,
  });
}
