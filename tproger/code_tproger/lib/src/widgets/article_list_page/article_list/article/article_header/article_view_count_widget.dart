import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/services/view_count_service.dart';

class ArticleViewCountWidget extends StatelessWidget {
  static final _viewCountService = GetIt.instance.get<ViewCountService>();

  final int viewCount;
  final bool isInvertetStyle;

  const ArticleViewCountWidget({
    required this.viewCount,
    required this.isInvertetStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.asset(
        Asset.eye.value,
        package: Asset.package,
        width: AppSize.articleViewCountIconSize,
        height: AppSize.articleViewCountIconSize,
        color: isInvertetStyle
          ? AppTheme.of(context).articleViewCountIconInvertedColor
          : AppTheme.of(context).articleViewCountIconColor,
      ),
      const SizedBox(width: AppSize.articleViewCountIconAndViewCountTextSeparatorSize),
      Text(
        _viewCountService.format(viewCount),
        textAlign: TextAlign.start,
        style: isInvertetStyle
          ? AppTheme.of(context).articleViewCountInvertedTextStyle
          : AppTheme.of(context).articleViewCountTextStyle,
      ),
    ],
  ); 
}
