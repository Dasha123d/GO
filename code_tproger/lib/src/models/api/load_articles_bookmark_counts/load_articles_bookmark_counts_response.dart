import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tproger_mobile_app/src/models/api/load_articles_bookmark_counts/article_bookmark_count_dto.dart';

part 'load_articles_bookmark_counts_response.g.dart';

@JsonSerializable(createToJson: false)
class LoadArticlesBookmarkCountsResponse extends Equatable {
  final List<ArticleBookmarkCountDto> counts;

  @override
  List<Object> get props => [counts];

  const LoadArticlesBookmarkCountsResponse(this.counts);

  factory LoadArticlesBookmarkCountsResponse.fromJson(List<dynamic> json) =>
    _$LoadArticlesBookmarkCountsResponseFromJson({'counts': json});
}
