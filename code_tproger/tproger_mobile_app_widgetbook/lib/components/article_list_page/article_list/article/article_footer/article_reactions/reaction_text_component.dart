import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions/reaction_text_widget.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buildReactionTextComponent(BuildContext context) => WidgetbookComponent(
  name: 'ReactionText',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const ReactionTextWidget(
        text: '5',
      ),
    ),
  ],
);