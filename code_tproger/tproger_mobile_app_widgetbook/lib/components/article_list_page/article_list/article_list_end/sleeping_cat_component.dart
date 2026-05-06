import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article_list_end/sleeping_cat_widget.dart';

WidgetbookComponent buildSleepingCatComponent(BuildContext context) => WidgetbookComponent(
  name: 'SleepingCat',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const SleepingCatWidget(),
    ),
  ],
);