import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'load_next_articles_response.g.dart';

@JsonSerializable(createToJson: false)
class LoadNextArticlesResponse extends Equatable {
  final String html;

  @override
  List<Object> get props => [html];

  const LoadNextArticlesResponse(this.html);

  factory LoadNextArticlesResponse.fromJson(String json) =>
    _$LoadNextArticlesResponseFromJson({'html': json});
}
