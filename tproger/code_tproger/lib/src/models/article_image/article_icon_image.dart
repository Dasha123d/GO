import 'package:tproger_mobile_app/src/models/article_image/article_image.dart';

class ArticleIconImage extends ArticleImage {  
  final String backgroundColor;
  
  const ArticleIconImage({
    required super.link,
    required this.backgroundColor,
  });

  @override
  List<Object> get props => [link, backgroundColor];
}
