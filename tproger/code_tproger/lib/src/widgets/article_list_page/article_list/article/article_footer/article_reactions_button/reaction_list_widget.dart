import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tproger_mobile_app/src/models/consts/app_common.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/services/reaction_service.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions_button/reaction_text_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions_button/reaction_widget.dart';

class ReactionListWidget extends StatelessWidget {
  static final _reactionService = GetIt.instance.get<ReactionService>();

  final List<ReactionData> reactions;

  List<ReactionData> get _visibleReactions => reactions.take(AppCommon.maxReactions).toList();
  int get _commonCount => _reactionService.commonCount(reactions);
  
  double get _width {
    final baseWidth = _visibleReactions.length * AppSize.articleReactionIconSize;

    if (_visibleReactions.length == 1) {
      return baseWidth + AppSize.articleReactionBorderSize * 2;
    } else if (_visibleReactions.length == 2) {
      return baseWidth + AppSize.reactionOffsetK * 2;
    } else if (_visibleReactions.length == 3) {
      return baseWidth + AppSize.reactionOffsetK;
    }

    throw UnsupportedError('Only ${AppCommon.maxReactions} reactions in the list');
  }

  const ReactionListWidget({ 
    required this.reactions,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: AppSize.articleReactionListSize,
        width: _width,
        child: Stack(
          children: _buildReactionWidgets(),
        ),
      ),
      const SizedBox(width: AppSize.articleReactionAndTextSeparatorSize),
      ReactionTextWidget(text: _commonCount.toString()),
    ],
  );

  List<Widget> _buildReactionWidgets() {
    final widgets = <Widget>[];

    for (var i = _visibleReactions.length - 1; i >= 0 ; i--) {
      final reaction = _visibleReactions[i].reaction;
      final icon = _reactionService.getIconByReaction(reaction);

      final widget = Positioned(
        left: i * AppSize.articleReactionIconSize  - i * AppSize.reactionOffsetK,
        child: ReactionWidget(icon: icon),
      );

      widgets.add(widget);
    }

    return widgets;
  }
}