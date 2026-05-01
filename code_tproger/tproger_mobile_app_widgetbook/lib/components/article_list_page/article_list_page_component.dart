import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_page_widget.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buildArticleListPageComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleListPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const ArticleListPageWidget(),
    ),
  ],
);