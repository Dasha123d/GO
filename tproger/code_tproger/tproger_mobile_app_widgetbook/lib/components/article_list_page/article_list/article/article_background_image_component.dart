import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/models/default_values.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_background_image_widget.dart';

WidgetbookComponent buildArticleBackgroundImageComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleBackgroundImage',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleBackgroundImageWidget(
        imageLink: KnobsService.imageLink(context, DefaultValues.backgroundImageLink),
        child: const SizedBox(
          width: double.infinity,
          height: 200,
          child: Text('Some content'),
        ),
      ),
    ),
  ],
);