// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_articles_bookmark_counts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadArticlesBookmarkCountsResponse _$LoadArticlesBookmarkCountsResponseFromJson(
        Map<String, dynamic> json) =>
    LoadArticlesBookmarkCountsResponse(
      (json['counts'] as List<dynamic>)
          .map((e) =>
              ArticleBookmarkCountDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
