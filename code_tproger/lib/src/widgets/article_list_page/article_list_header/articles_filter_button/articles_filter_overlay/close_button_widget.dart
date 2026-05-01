import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidFunction onClick;

  const CloseButtonWidget({ 
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onClick,
    child: Padding(
      padding: AppSize.articlesFilterOverlayCloseButtonPadding,
      child: SvgPicture.asset(
        Asset.cross.value,
        package: Asset.package,
        width: AppSize.articlesFilterOverlayCloseButtonIconSize,
        height: AppSize.articlesFilterOverlayCloseButtonIconSize,
        color: AppTheme.of(context).articlesFilterOverlayCloseButtonIconColor,
      ),
    ),
  );
}