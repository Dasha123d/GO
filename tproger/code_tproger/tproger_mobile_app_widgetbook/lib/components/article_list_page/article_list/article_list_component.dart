import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/helper_service.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_widget.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';

WidgetbookComponent buildArticleListComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleList',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleListWidget(
        articles: <ArticleModel>[
          for (var i = 0; i < KnobsService.countOfArticles(context); i++)
            HelperService.createArticleModel(id: i)
        ],
        isFullLoaded: KnobsService.isFullLoaded(context),
      ),
    ),
  ],
);