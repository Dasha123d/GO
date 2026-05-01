import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_header/article_view_count_widget.dart';

WidgetbookComponent buildArticleViewCountComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleViewCount',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleViewCountWidget(
        viewCount: KnobsService.viewCount(context),
        isInvertetStyle: KnobsService.isInvertetStyle(context),
      ),
    ),
  ],
);