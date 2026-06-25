import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_end/article_list_end_widget.dart';

WidgetbookComponent buildArticleListEndComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleListEnd',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const ArticleListEndWidget(),
    ),
  ],
);