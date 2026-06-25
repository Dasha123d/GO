import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/article_reactions_dto.dart';

part 'load_article_reactions_response.g.dart';

@JsonSerializable(createToJson: false)
class LoadArticleReactionsResponse extends Equatable {
  final List<ArticleReactionsDto> articleReactions;

  @override
  List<Object> get props => [articleReactions];

  const LoadArticleReactionsResponse(this.articleReactions);

  factory LoadArticleReactionsResponse.fromJson(List<dynamic> json) =>
    _$LoadArticleReactionsResponseFromJson({'articleReactions': json});
}
