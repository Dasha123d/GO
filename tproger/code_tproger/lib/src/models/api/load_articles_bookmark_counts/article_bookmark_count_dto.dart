import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_bookmark_count_dto.g.dart';

@JsonSerializable(createToJson: false)
class ArticleBookmarkCountDto extends Equatable {
  @JsonKey(name: 'post')
  final int articleId;

  final int count;

  @override
  List<Object> get props => [articleId, count];

  const ArticleBookmarkCountDto({
    required this.articleId,
    required this.count,
  });

  factory ArticleBookmarkCountDto.fromJson(Map<String, dynamic> json) =>
    _$ArticleBookmarkCountDtoFromJson(json);
}
