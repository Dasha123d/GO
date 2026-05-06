import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_content/article_content_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_content/article_description_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_content/article_image_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_content/article_title_component.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleContentFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleContent',
  widgets: [
    buildArticleContentComponent(context),
    buildArticleContentImageComponent(context),
    buildArticleDescriptionComponent(context),
    buildArticleTitleComponent(context),
  ],
);