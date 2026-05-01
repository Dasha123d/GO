import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_reactions/add_reaction_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_reactions/article_reactions_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_reactions/reaction_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_reactions/reaction_list_component.dart';
import 'package:tproger_mobile_app_widgetbook/components/article_list_page/article_list/article/article_footer/article_reactions/reaction_text_component.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildArticleReactionsFolder(BuildContext context) => WidgetbookFolder(
  name: 'ArticleReactions',
  widgets: [
    buildArticleReactionsComponent(context),
    buildReactionTextComponent(context),
    buildAddReactionComponent(context),
    buildReactionListComponent(context),
    buildReactionComponent(context),
  ],
);