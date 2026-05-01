import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_title_widget.dart';

WidgetbookComponent buildArticleTitleComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleTitle',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleTitleWidget(
        text: KnobsService.title(context),
        isInvertetStyle: KnobsService.isInvertetStyle(context),
      ),
    ),
  ],
);