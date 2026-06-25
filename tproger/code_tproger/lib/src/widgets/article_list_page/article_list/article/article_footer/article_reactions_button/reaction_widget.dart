import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';

class ReactionWidget extends StatelessWidget {
  final Asset icon;

  const ReactionWidget({ 
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: AppSize.articleReactionBorderSize,
        color: AppTheme.of(context).articleReactionBorderColor,
      ),
    ),
    child: SvgPicture.asset(
      icon.value,
      package: Asset.package,
      width: AppSize.articleReactionIconSize,
      height: AppSize.articleReactionIconSize,
    ),
  );
}