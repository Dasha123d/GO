// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_next_articles_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$LoadNextArticlesRequestToJson(
        LoadNextArticlesRequest instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hashCode': instance.hashCode,
      'action': instance.action,
      'page': instance.pageNumber,
      'sort': ArticlesSortType.staticToString(instance.sortType),
      'tags':
          LoadNextArticlesRequest._isForBeginnerToJson(instance.isForBeginner),
      'props': instance.props,
    };
