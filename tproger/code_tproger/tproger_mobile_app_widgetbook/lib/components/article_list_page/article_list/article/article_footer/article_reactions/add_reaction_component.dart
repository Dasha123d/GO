import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions/add_reaction_widget.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buildAddReactionComponent(BuildContext context) => WidgetbookComponent(
  name: 'AddReaction',
  useCases: [
    WidgetbookUseCase(
      name: 'Default', 
      builder: (context) => const AddReactionWidget(),
    ),
  ],
);