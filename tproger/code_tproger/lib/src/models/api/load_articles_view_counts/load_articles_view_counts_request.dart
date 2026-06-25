import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'load_articles_view_counts_request.g.dart';

@JsonSerializable(createFactory: false)
class LoadArticlesViewCountsRequest extends Equatable {
  final String ids;

  @override
  List<Object> get props => [ids];

  const LoadArticlesViewCountsRequest(this.ids);

  Map<String, dynamic> toJson() =>
    _$LoadArticlesViewCountsRequestToJson(this);
}
