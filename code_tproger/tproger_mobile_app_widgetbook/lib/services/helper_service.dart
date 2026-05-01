import 'package:tproger_mobile_app/src/models/article_model.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_icon_image.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_background_image.dart';
import 'package:tproger_mobile_app/src/models/article_author.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app_widgetbook/models/default_values.dart';

class HelperService {
  static ArticleModel createArticleModel({
    int id = 0, 
    String title = 'Title',
    String description = 'Description',
    int bookmarkCount = 0,
    int commentCount = 0,
    List<ReactionData> reactions = const [],
    int viewCount = 0,
    String authorName = 'Author',
    bool isBackgroundImage = false,
    String backgroundColor = DefaultValues.backgroundColorHex,
  }) => ArticleModel(
    id: id,
    title: title,
    description: description,
    articleLink: '',
    bookmarkCount: bookmarkCount,
    commentCount: commentCount,
    reactions: reactions,
    viewCount: viewCount,
    author: ArticleAuthor(
      avatarLink: DefaultValues.avatarLink,
      name: authorName,
    ),
    image: isBackgroundImage
      ? const ArticleBackgroundImage(
          link: DefaultValues.backgroundImageLink,
        )
      : ArticleIconImage(
          backgroundColor: backgroundColor,
          link: DefaultValues.iconImageLink,
        ),
  );
}