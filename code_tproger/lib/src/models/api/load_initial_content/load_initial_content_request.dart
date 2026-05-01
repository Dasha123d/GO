import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';

part 'load_initial_content_request.g.dart';

@JsonSerializable(createFactory: false)
class LoadInitialContentRequest extends Equatable {
  @JsonKey(
    name: 'sort',
    toJson: ArticlesSortType.staticToString,
  )
  final ArticlesSortType sortType;

  @JsonKey(
    name: 'tags',
    toJson: _isForBeginnerToJson,
  )
  final bool isForBeginner;

  @override
  List<Object> get props => [sortType, isForBeginner];

  const LoadInitialContentRequest({
    required this.sortType,
    required this.isForBeginner,
  });

  Map<String, dynamic> toJson() =>
    _$LoadInitialContentRequestToJson(this);

  static String? _isForBeginnerToJson(bool value) => 
    value ? 'on' : null;
}
