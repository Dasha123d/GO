// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_articles_view_counts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadArticlesViewCountsResponse _$LoadArticlesViewCountsResponseFromJson(
        Map<String, dynamic> json) =>
    LoadArticlesViewCountsResponse(
      (json['counts'] as List<dynamic>)
          .map((e) => ArticleViewCountDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
