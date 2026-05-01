import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article_list_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article_list_loader_component.dart';
import 'package:tproger_mobile_app_widgetbook/folders/article_folder.dart';
import 'package:tproger_mobile_app_widgetbook/folders/article_list_end_folder.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleListFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleList',
  widgets: [
    buildArticleListComponent(context),
    buildArticleListLoaderComponent(context),
  ],
  folders: [
    buildArticleListEndFolder(context),
    buildArticleFolder(context),
  ],
);