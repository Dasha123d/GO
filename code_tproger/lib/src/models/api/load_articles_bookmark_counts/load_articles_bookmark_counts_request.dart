import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'load_articles_bookmark_counts_request.g.dart';

@JsonSerializable(createFactory: false)
class LoadArticlesBookmarkCountsRequest extends Equatable {
  final String ids;

  @override
  List<Object> get props => [ids];

  const LoadArticlesBookmarkCountsRequest(this.ids);

  Map<String, dynamic> toJson() =>
    _$LoadArticlesBookmarkCountsRequestToJson(this);
}
