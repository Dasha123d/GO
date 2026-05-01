import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_footer_widget.dart';

WidgetbookComponent buildArticleFooterComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleFooter',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleFooterWidget(
        bookmarkCount: KnobsService.bookmarkCount(context),
        commentCount: KnobsService.commentCount(context),
        isInvertetStyle: KnobsService.isInvertetStyle(context),
        reactions: KnobsService.reactions(context),
      ),
    ),
  ],
);