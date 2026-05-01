import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/models/default_values.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_icon_image.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';

class KnobsService {
  static bool isFullLoaded(BuildContext context) => context.knobs.boolean(
    label: 'Is list full loaded',
    initialValue: false,
  );

  static int footerButtonCount(BuildContext context) => context.knobs.number(
    label: 'Count of bookmarks/comments',
    initialValue: 0,
  ).toInt();

  static Asset reactionIcon(BuildContext context) => context.knobs.options(
    label: 'Reaction icon', 
    options: const [
      Option(
        label: 'Like',
        value: Asset.like,
      ),
      Option(
        label: 'Angry',
        value: Asset.angry,
      ),
      Option(
        label: 'Laugh',
        value: Asset.laugh,
      ),
      Option(
        label: 'Surprise',
        value: Asset.surprise,
      ),
      Option(
        label: 'Think',
        value: Asset.think,
      ),
    ],
  );

  static Asset footerButtonIcon(BuildContext context) => context.knobs.options(
    label: 'Footer button icon', 
    options: const [
      Option(
        label: 'Comment',
        value: Asset.comment,
      ),
      Option(
        label: 'Bookmark',
        value: Asset.bookmark,
      ),
    ],
  );

  static ArticleIconImage? image(BuildContext context) => context.knobs.boolean(
    label: 'Has image',
    initialValue: false,
  ) ? _iconImage(context) : null;
      
  static String avatarLink(BuildContext context) => context.knobs.text(
    initialValue: DefaultValues.avatarLink,
    label: 'Network link to an avatar'
  );

  static ArticleAuthor author(BuildContext context) => ArticleAuthor(
    avatarLink: KnobsService.avatarLink(context),
    name: KnobsService.authorName(context),
  );

  static bool isInvertetStyle(BuildContext context) => context.knobs.boolean(
    label: 'Enable inverted style',
    initialValue: false,
  );

  static String imageLink(BuildContext context, String defaultValue) => context.knobs.text(
    initialValue: defaultValue,
    label: 'Network link to an image',
  );

  static bool isBackgroundImage(BuildContext context) => context.knobs.boolean(
    label: 'Has background image if true else icon',
    initialValue: false,
  );

  static String backgroundColorHex(BuildContext context, {String? description}) => context.knobs.text(
    initialValue: DefaultValues.backgroundColorHex,
    label: 'Color of a background',
    description: description,
  );

  static Color backgroundColor(BuildContext context) => Color.fromRGBO(
    context.knobs.slider(
      label: 'Red',
      divisions: 255,
      initialValue: 0,
      min: 0,
      max: 255,
    ).toInt(), 
    context.knobs.slider(
      label: 'Green',
      divisions: 255,
      initialValue: 0,
      min: 0,
      max: 255,
    ).toInt(),
    context.knobs.slider(
      label: 'Blue',
      divisions: 255,
      initialValue: 0,
      min: 0,
      max: 255,
    ).toInt(),
    1,
  );

  static String authorName(BuildContext context) => context.knobs.text(
    label: 'Author name',
    initialValue: 'Author Name',
  );

  static String title(BuildContext context) => context.knobs.text(
    label: 'Title of an article',
    initialValue: 'Title of an article',
  );

  static String description(BuildContext context) => context.knobs.text(
    label: 'Description of an article',
    initialValue: 'Description of an article',
  );

  static int viewCount(BuildContext context) => context.knobs.number(
    label: 'Count of views',
    initialValue: 0,
  ).toInt();

  static int bookmarkCount(BuildContext context) => context.knobs.number(
    label: 'Count of bookmarks',
    initialValue: 0,
  ).toInt();

  static int commentCount(BuildContext context) => context.knobs.number(
    label: 'Count of comments',
    initialValue: 0,
  ).toInt();

  static int countOfArticles(BuildContext context) => context.knobs.number(
    label: 'Count of articles',
    initialValue: 0,
  ).toInt();

  static List<ReactionData> reactions(BuildContext context) {
    final angryReactionCount = KnobsService._angryReactionCount(context);
    final surpirseReactionCount = KnobsService._surpirseReactionCount(context);
    final thinkReactionCount = KnobsService._thinkingReactionCount(context);
    final laughReactionCount = KnobsService._laughReactionCount(context);
    final likeReactionCount = KnobsService._likeReactionCount(context);

    return [
      if (angryReactionCount > 0) ReactionData(
        reaction: Reaction.angry, 
        count: angryReactionCount,
      ), 
      if (surpirseReactionCount > 0) ReactionData(
        reaction: Reaction.surprise,
        count: surpirseReactionCount,
      ), 
      if (thinkReactionCount > 0) ReactionData(
        reaction: Reaction.think,
        count: thinkReactionCount, 
      ),
      if (laughReactionCount > 0) ReactionData(
        reaction: Reaction.laugh,
        count: laughReactionCount, 
      ),
      if (likeReactionCount > 0) ReactionData(
        reaction: Reaction.like,
        count: likeReactionCount, 
      ),
    ];
  }

  static int _angryReactionCount(BuildContext context) => context.knobs.number(
    label: 'Count of angry reactions',
    initialValue: 0,
  ).toInt();

  static int _surpirseReactionCount(BuildContext context) => context.knobs.number(
    label: 'Count of surprise reactions',
    initialValue: 0,
  ).toInt();
  
  static int _thinkingReactionCount(BuildContext context) => context.knobs.number(
    label: 'Count of thinking reactions',
    initialValue: 0,
  ).toInt();
  
  static int _laughReactionCount(BuildContext context) => context.knobs.number(
    label: 'Count of laugh reactions',
    initialValue: 0,
  ).toInt();
  
  static int _likeReactionCount(BuildContext context) => context.knobs.number(
    label: 'Count of like reactions',
    initialValue: 0,
  ).toInt();

  static ArticleIconImage _iconImage(BuildContext context) => ArticleIconImage(
    backgroundColor: KnobsService.backgroundColorHex(context),
    link: KnobsService.imageLink(context, DefaultValues.iconImageLink),
  );
}