import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/models/default_values.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_image_widget.dart';

WidgetbookComponent buildArticleContentImageComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleImage',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleImageWidget(
        backgroundColor: KnobsService.backgroundColor(context),
        link: KnobsService.imageLink(context, DefaultValues.iconImageLink),
      ),
    ),
  ],
);