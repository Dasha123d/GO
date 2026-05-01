import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tproger_mobile_app/src/models/api/load_article_reactions/article_reaction_dto.dart';

part 'article_reactions_dto.g.dart';

@JsonSerializable(createToJson: false)
class ArticleReactionsDto extends Equatable {
  @JsonKey(name: 'post')
  final int articleId;

  final List<ArticleReactionDto> reactions;

  @override
  List<Object> get props => [articleId, reactions];

  const ArticleReactionsDto({
    required this.articleId,
    required this.reactions,
  });

  factory ArticleReactionsDto.fromJson(Map<String, dynamic> json) =>
    _$ArticleReactionsDtoFromJson(json);
}
