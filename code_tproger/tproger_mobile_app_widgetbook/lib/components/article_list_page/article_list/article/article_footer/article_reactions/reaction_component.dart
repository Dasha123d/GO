import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions/reaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buildReactionComponent(BuildContext context) => WidgetbookComponent(
  name: 'Reaction',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ReactionWidget(
       icon: KnobsService.reactionIcon(context),
      ),
    ),
  ],
);