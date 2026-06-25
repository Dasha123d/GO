import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleAuthorAvatarWidget extends StatelessWidget {
  static final _logger = GetIt.instance.get<Logger>();

  final String avatarLink;

  const ArticleAuthorAvatarWidget({
    required this.avatarLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppSize.articleAuthorAvatarRadius,
    child: SizedBox(
      width: AppSize.articleAuthorAvatarSize,
      height: AppSize.articleAuthorAvatarSize,      
      child: FadeInImage.memoryNetwork(
        image: avatarLink,
        placeholder: kTransparentImage,
        imageErrorBuilder: _imageErrorBuilder,
      ),
    ),
  );

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    _logger.w('Cannot load the article author avatar image "$avatarLink"');

    return Image.asset(
      Asset.defaultAvatar.value,
      package: Asset.package,
    );
  }
}
