// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_reactions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleReactionsDto _$ArticleReactionsDtoFromJson(Map<String, dynamic> json) =>
    ArticleReactionsDto(
      articleId: json['post'] as int,
      reactions: (json['reactions'] as List<dynamic>)
          .map((e) => ArticleReactionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
