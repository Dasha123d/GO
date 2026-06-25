import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tproger_mobile_app/l10n/app_localizations.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class ReadUsTelegramButtonWidget extends StatefulWidget {
  final VoidFunction onClick;

  const ReadUsTelegramButtonWidget({ 
    required this.onClick,
    super.key,
  });

  @override
  State<ReadUsTelegramButtonWidget> createState() => _ReadUsTelegramButtonWidgetState();
}

class _ReadUsTelegramButtonWidgetState extends State<ReadUsTelegramButtonWidget> {
  static const _opacityDuration = Duration(milliseconds: 250);
  static const _rotationDuration = Duration(milliseconds: 500);

  bool _isTapped = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: _onTapDown,
    onTapUp: _onTapUp,
    onTapCancel: _onTapCancel,
    child: AnimatedOpacity(
      duration: _opacityDuration,
      curve: Curves.ease,
      opacity: _isTapped? 0.7 : 1,
      child: Container(
        padding: AppSize.readUsTelegramButtonPadding,
        decoration: BoxDecoration(
          color: AppTheme.of(context).readUsTelegramButtonColor,
          border: Border.all(
            color: AppTheme.of(context).readUsTelegramButtonBorderColor,
            width: 1,
          ),
          borderRadius: AppSize.readUsTelegramButtonBorderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedRotation(
              duration: _rotationDuration,
              turns: _isTapped? 1 : 0,
              child: SvgPicture.asset(
                Asset.telegram1.value,
                package: Asset.package,
                height: AppSize.readUsTelegramButtonIconSize,
                width: AppSize.readUsTelegramButtonIconSize,
                color: AppTheme.of(context).readUsTelegramButtonIconColor,
              ),
            ),
            const SizedBox(width: AppSize.readUsTelegramButtonIconAndTextSeparatorSize),
            Text(
              AppLocalizations.of(context)!.readUsInTelegramText,
              style: AppTheme.of(context).readUsTelegramButtonTextStyle,
            ),
          ],
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) => setState(() {
    _isTapped = true; 
  });

  void _onTapCancel() => setState(() {
    _isTapped = false;
  });

  void _onTapUp(TapUpDetails details) {
    widget.onClick();

    setState(() { 
      _isTapped = false;
    });
  }
}
