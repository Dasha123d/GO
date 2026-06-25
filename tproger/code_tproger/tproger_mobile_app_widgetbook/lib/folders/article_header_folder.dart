import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_header/article_author_avatar_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_header/article_author_name_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_header/article_header_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_header/article_view_count_component.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleHeaderFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleHeader',
  widgets: [
    buildArticleHeaderComponent(context),
    buildArticleAuthorNameComponent(context),
    buildArticleAuthorAvatarComponent(context),
    buildArticleViewCountComponent(context),
  ],
);