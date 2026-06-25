import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_loader_widget.dart';

WidgetbookComponent buildArticleListLoaderComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleListLoader',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const ArticleListLoaderWidget(),
    ),
  ],
);