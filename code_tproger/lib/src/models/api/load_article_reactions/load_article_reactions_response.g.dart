// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_article_reactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadArticleReactionsResponse _$LoadArticleReactionsResponseFromJson(
        Map<String, dynamic> json) =>
    LoadArticleReactionsResponse(
      (json['articleReactions'] as List<dynamic>)
          .map((e) => ArticleReactionsDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
