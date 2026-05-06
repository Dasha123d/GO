import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tproger_mobile_app/src/models/consts/app_color.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleBackgroundImageWidget extends StatelessWidget {  
  static final _logger = GetIt.instance.get<Logger>();

  final String imageLink;
  final Widget child;
  
  const ArticleBackgroundImageWidget({
    required this.imageLink,
    required this.child,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: ClipRect(
          clipBehavior: Clip.hardEdge,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: AppSize.articleImageBlurSize,
              sigmaY: AppSize.articleImageBlurSize,
              tileMode: TileMode.decal,
            ),
            child: Container(
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.1185, 0.906],
                  colors: [
                    AppColor.blackColor0.withOpacity(0.8),
                    AppColor.blackColor0.withOpacity(0.4),
                  ],
                ),
              ),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                image: imageLink,
                placeholder: kTransparentImage,
                imageErrorBuilder: _imageErrorBuilder,
              ),
            ),
          ),
        ),
      ),
      child,
    ],
  );

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    _logger.w('Cannot load the article background image "$imageLink"');

    return const SizedBox.shrink();
  }
}