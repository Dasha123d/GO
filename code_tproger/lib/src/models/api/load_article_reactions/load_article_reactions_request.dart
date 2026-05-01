import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'load_article_reactions_request.g.dart';

@JsonSerializable(createFactory: false)
class LoadArticleReactionsRequest extends Equatable  {
  final String ids;

  @override
  List<Object> get props => [ids];

  const LoadArticleReactionsRequest(this.ids);

  Map<String, dynamic> toJson() => _$LoadArticleReactionsRequestToJson(this);
}
