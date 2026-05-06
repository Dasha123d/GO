import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_view_counts/article_view_count_dto.dart';

part 'load_articles_view_counts_response.g.dart';

@JsonSerializable(createToJson: false)
class LoadArticlesViewCountsResponse extends Equatable {
  final List<ArticleViewCountDto> counts;

  @override
  List<Object> get props => [counts];

  const LoadArticlesViewCountsResponse(this.counts);

  factory LoadArticlesViewCountsResponse.fromJson(List<dynamic> json) =>
    _$LoadArticlesViewCountsResponseFromJson({'counts': json});
}
