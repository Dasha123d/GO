import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list_loader_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list_page_component.dart';
import 'package:tproger_mobile_app_widgetbook/folders/article_list_folder.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleListPageFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleListPage',
  widgets: [
    buildArticleListPageComponent(context),
    buildArticleListLoaderComponent(context),
  ],
  folders: [
    buildArticleListFolder(context),
  ],
);