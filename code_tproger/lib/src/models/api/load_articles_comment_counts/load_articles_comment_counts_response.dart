import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_comment_counts/article_comment_count_dto.dart';

part 'load_articles_comment_counts_response.g.dart';

@JsonSerializable(createToJson: false)
class LoadArticlesCommentCountsResponse extends Equatable {
  final List<ArticleCommentCountDto> counts;

  @override
  List<Object> get props => [counts];

  const LoadArticlesCommentCountsResponse(this.counts);

  factory LoadArticlesCommentCountsResponse.fromJson(List<dynamic> json) =>
    _$LoadArticlesCommentCountsResponseFromJson({'counts': json});
}
