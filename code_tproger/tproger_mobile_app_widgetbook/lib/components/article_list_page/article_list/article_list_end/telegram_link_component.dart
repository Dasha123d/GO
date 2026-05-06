import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_end/telegram_link_widget.dart';

WidgetbookComponent buildTelegramLinkComponent(BuildContext context) => WidgetbookComponent(
  name: 'TelegramLink',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const TelegramLinkWidget(),
    ),
  ],
);