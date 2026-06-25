import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/services/knobs_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_header/article_author_avatar_widget.dart';

WidgetbookComponent buildArticleAuthorAvatarComponent(BuildContext context) => WidgetbookComponent(
  name: 'ArticleAuthorAvatar',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => ArticleAuthorAvatarWidget(
        avatarLink: KnobsService.avatarLink(context),
      ),
    ),
  ],
);