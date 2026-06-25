import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_background_image.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_icon_image.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_image.dart';
import 'package:tproger_mobile_app/src/models/web_hex_color.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_description_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_image_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_content/article_title_widget.dart';

class ArticleContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final ArticleImage? image;

  bool get _hasContentImage => image is ArticleIconImage;
  bool get _hasBackgroundImage => image is ArticleBackgroundImage;

  Color? get _backgroundColor {
    if (image is ArticleIconImage) {
      final iconImage = image as ArticleIconImage;
      return WebHexColor(iconImage.backgroundColor);
    }

    return null;
  }

  const ArticleContentWidget({
    required this.title,
    required this.description,
    this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_hasContentImage) ...[
        ArticleImageWidget(
          link: image!.link,
          backgroundColor: _backgroundColor!,
        ),
        const SizedBox(height: AppSize.articleImageAndTitleSeparatorSize),
      ],
      ArticleTitleWidget(
        text: title,
        isInvertetStyle: _hasBackgroundImage,
      ),
      const SizedBox(height: AppSize.articleTitleAndDescriptionSeparatorSize),
      ArticleDescriptionWidget(
        text: description,
        isInvertetStyle: _hasBackgroundImage,
      ),
    ],
  );
}
