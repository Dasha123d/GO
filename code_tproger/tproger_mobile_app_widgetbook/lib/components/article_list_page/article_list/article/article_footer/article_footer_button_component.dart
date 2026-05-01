import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_footer_button_widget.dart';

WidgetbookComponent buildArticleFooterButtonComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleFooterButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleFooterButtonWidget(
        count: KnobsService.footerButtonCount(context),
        icon: KnobsService.footerButtonIcon(context),
        isInvertetStyle: KnobsService.isInvertetStyle(context),
      ),
    ),
  ],
);