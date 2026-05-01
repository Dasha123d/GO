import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_description_widget.dart';

WidgetbookComponent buildArticleDescriptionComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleDescription',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleDescriptionWidget(
        text: KnobsService.description(context),
        isInvertetStyle: KnobsService.isInvertetStyle(context),
      ),
    ),
  ],
);
 