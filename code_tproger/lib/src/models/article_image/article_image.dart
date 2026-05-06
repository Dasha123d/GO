import 'package:equatable/equatable.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_background_image.dart';
import 'package:tproger_mobile_app/src/models/article_image/article_icon_image.dart';

abstract class ArticleImage extends Equatable {
  final String link;

  const ArticleImage({required this.link});

  factory ArticleImage.from({
    required String link,
    String? backgroundColor,
  }) => (backgroundColor == null)
    ? ArticleBackgroundImage(link: link)
    : ArticleIconImage(link: link, backgroundColor: backgroundColor);

  @override
  List<Object> get props => [link];
}
