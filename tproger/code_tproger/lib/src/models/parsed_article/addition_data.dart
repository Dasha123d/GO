import 'package:equatable/equatable.dart';
import 'package:tproger_mobile_app/src/models/parsed_article/parsed_article.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';

class AdditionalData extends Equatable {
  final ParsedArticle sourceArticle;
  final int commentCount;
  final int bookmarkCount;
  final int viewCount;
  final List<ReactionData> reactions;

  const AdditionalData({
    required this.sourceArticle,
    required this.commentCount,
    required this.bookmarkCount,
    required this.viewCount,
    required this.reactions,
  });

  @override
  List<Object> get props => [sourceArticle, commentCount, bookmarkCount, viewCount, reactions];
}
