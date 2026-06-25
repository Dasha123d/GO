import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_header/article_author_avatar_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_header/article_author_name_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_header/article_view_count_widget.dart';

class ArticleHeaderWidget extends StatelessWidget {
  final ArticleAuthor? author;
  final int viewCount;
  final bool isInvertetStyle;

  bool get _hasAuthor => author != null;

  const ArticleHeaderWidget({
    required this.author,
    required this.viewCount,
    required this.isInvertetStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (_hasAuthor) ...[
        ArticleAuthorAvatarWidget(avatarLink: author!.avatarLink),
        const SizedBox(width: AppSize.articleAuthorAvatarAndNameSeparatorSize),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSize.articleAuthorNameMaxWidth,
          ),
          child: ArticleAuthorNameWidget(
            authorName: author!.name,
            isInvertetStyle: isInvertetStyle,
          ),
        ),
        const SizedBox(width: AppSize.articleAuthorNameAndViewCountSeparatorSize),
      ],
      if (viewCount != 0) ArticleViewCountWidget(
        viewCount: viewCount,
        isInvertetStyle: isInvertetStyle,
      ),
    ],
  );
}
