import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article_list_end/article_list_end_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article_list_end/sleeping_cat_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article_list_end/telegram_link_component.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleListEndFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleListEnd',
  widgets: [
    buildArticleListEndComponent(context),
    buildSleepingCatComponent(context),
    buildTelegramLinkComponent(context),
  ],
);