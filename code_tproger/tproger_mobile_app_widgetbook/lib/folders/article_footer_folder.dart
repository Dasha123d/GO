import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_footer_button_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_footer_component.dart';
import 'package:tproger_mobile_app_widgetbook/folders/article_reactions_folder.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleFooterFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleFooter',
  folders: [
    buildArticleReactionsFolder(context),
  ],
  widgets: [
    buildArticleFooterComponent(context),
    buildArticleFooterButtonComponent(context),
  ],
);