import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions/article_reactions_widget.dart';

WidgetbookComponent buildArticleReactionsComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleReactions',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleReactionsWidget(
        reactions: KnobsService.reactions(context),
      ),
    ),
  ],
);