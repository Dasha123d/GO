import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleImageWidget extends StatelessWidget {
  static final _logger = GetIt.instance.get<Logger>();

  final String link;
  final Color backgroundColor;

  const ArticleImageWidget({
    required this.link,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: AppSize.articleImageContainerHeight,
    width: double.infinity,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: AppSize.articleImageRadius,
    ),
    child: Center(
      child: SizedBox(
        height: AppSize.articleImageHeight,
        width: AppSize.articleImageHeight,
        child: FadeInImage.memoryNetwork(
          image: link,
          placeholder: kTransparentImage,
          imageErrorBuilder: _imageErrorBuilder,
        ),
      ),
    ),
  );

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    _logger.w('Cannot load the article icon image "$link"');

    return const SizedBox.shrink();
  }
}
