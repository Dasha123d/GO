import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/l10n/app_localizations.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class ApplyButtonWidget extends StatefulWidget {
  final VoidFunction onClick;

  const ApplyButtonWidget({ 
    required this.onClick,
    super.key,
  });

  @override
  State<ApplyButtonWidget> createState() => _ApplyButtonWidgetState();
}

class _ApplyButtonWidgetState extends State<ApplyButtonWidget> {
  static const _duration = Duration(milliseconds: 250);

  var _isTapped = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapUp: _onTapUp,
    onTapDown: _onTapDown,
    onTapCancel: _onTapCancel,
    child: AnimatedOpacity(
      duration: _duration,
      curve: Curves.ease,
      opacity: _isTapped? 0.7 : 1,
      child: Container(
        padding: AppSize.articlesFilterOverlayHeaderButtonPadding,
        decoration: BoxDecoration(
          border: Border.all(
            width: AppSize.articlesFilterOverlayHeaderButtonBorderSize,
            color: Colors.transparent,
          ),
          borderRadius: AppSize.articlesFilterOverlayHeaderButtonBorderRadius,
          color: AppTheme.of(context).articlesFilterOverlayApplyButtonColor,
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.applyText,
            style: AppTheme.of(context).articlesFilterOverlayApplyButtonTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  void _onTapUp(TapUpDetails detail) {
    widget.onClick();

    setState(() { 
      _isTapped = false;
    });
  }

  void _onTapDown(TapDownDetails detail) => setState(() { 
    _isTapped = true;
  });

  void _onTapCancel() => setState(() {
    _isTapped = false;
  });
}
