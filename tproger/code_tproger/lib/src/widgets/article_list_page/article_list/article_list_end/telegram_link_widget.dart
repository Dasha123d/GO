import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tproger_mobile_app/l10n/app_localizations.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_common.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class TelegramLinkWidget extends StatelessWidget {
  final VoidFunction onClick;

  const TelegramLinkWidget({ 
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SvgPicture.asset(
        Asset.telegram0.value,
        package: Asset.package,
        width: AppSize.articleListEndTelegramIconSize,
        height: AppSize.articleListEndTelegramIconSize,
      ),
      const SizedBox(height: AppSize.articleListEndTelegramIconAndTextSeparatorSize),
      Text(
        AppLocalizations.of(context)!.orFindInOurTelegramChannelsText,
        style: AppTheme.of(context).articleListEndTelegramTextStyle,
        textAlign: TextAlign.center,
      ),
      GestureDetector(
        onTap: onClick,
        child: Text(
          AppCommon.tprogerTelegramLinkText,
          style: AppTheme.of(context).articleListEndTelegramLinkTextStyle,
        ),
      ),
    ],
  );
}
