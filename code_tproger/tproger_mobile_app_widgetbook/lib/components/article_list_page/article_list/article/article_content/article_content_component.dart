import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_content_widget.dart';


WidgetbookComponent buildArticleContentComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleContent',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleContentWidget(
        title: KnobsService.title(context),
        description: KnobsService.description(context),
        image: KnobsService.image(context),
      ),
    ),
  ],
);