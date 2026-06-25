import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_header/article_header_widget.dart';

WidgetbookComponent buildArticleHeaderComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleHeader',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleHeaderWidget(
        author: KnobsService.author(context),
        viewCount: KnobsService.viewCount(context),
        isInvertetStyle: KnobsService.isInvertetStyle(context),
      ),
    ),
  ],
);