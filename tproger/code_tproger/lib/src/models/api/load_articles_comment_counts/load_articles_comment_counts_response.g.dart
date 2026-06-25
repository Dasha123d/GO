// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_articles_comment_counts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadArticlesCommentCountsResponse _$LoadArticlesCommentCountsResponseFromJson(
        Map<String, dynamic> json) =>
    LoadArticlesCommentCountsResponse(
      (json['counts'] as List<dynamic>)
          .map((e) => ArticleCommentCountDto.fromJson(e))
          .toList(),
    );
