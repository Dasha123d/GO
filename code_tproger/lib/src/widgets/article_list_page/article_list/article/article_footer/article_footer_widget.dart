import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_footer_button_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions_button/article_reactions_button_widget.dart';

class ArticleFooterWidget extends StatelessWidget {
  final int bookmarkCount;
  final int commentCount;
  final List<ReactionData> reactions;
  final bool isInvertetStyle;
  final VoidFunction onCommentClick;
  final VoidFunction onBookmarkClick;

  const ArticleFooterWidget({
    required this.bookmarkCount,
    required this.commentCount,
    required this.reactions,
    required this.isInvertetStyle,
    required this.onCommentClick,
    required this.onBookmarkClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Row(
          children: [
            ArticleFooterButtonWidget(
              icon: Asset.bookmark,
              count: bookmarkCount,
              isInvertetStyle: isInvertetStyle,
              onClick: onBookmarkClick,
            ),
            const SizedBox(width: AppSize.articleFooterButtonsSeparatorSize),
            ArticleFooterButtonWidget(
              icon: Asset.comment,
              count: commentCount,
              isInvertetStyle: isInvertetStyle,
              onClick: onCommentClick,
            ),
          ],
        ),
      ),
      Flexible(
        child: FittedBox(
          child: ArticleReactionsButtonWidget(
            reactions: reactions,
          ),
        ),
      ),
    ],
  );
}
