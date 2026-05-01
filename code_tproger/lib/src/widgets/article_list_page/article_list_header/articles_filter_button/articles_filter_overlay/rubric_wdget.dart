import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/l10n/app_localizations.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class RubricWidget extends StatefulWidget {
  final bool isForBeginner;
  final VoidFunction onIsForBeginnerClick;

  const RubricWidget({ 
    required this.isForBeginner,
    required this.onIsForBeginnerClick,
    super.key,
  });

  @override
  State<RubricWidget> createState() => _RubricWidgetState();
}

class _RubricWidgetState extends State<RubricWidget> {
  static const _duration = Duration(milliseconds: 250);

  var _isTapped = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppLocalizations.of(context)!.rubricsText,
        style: AppTheme.of(context).articlesFilterOverlayRubricTitleTextStyle,
      ),
      const SizedBox(height: AppSize.articlesFilterOverlayRubricTitleAndContentSeparatorSize),
      GestureDetector(
        onTapUp: _onTapUp,
        onTapDown: _onTapDown,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.translucent,
        child: AnimatedOpacity(
          duration: _duration,
          curve: Curves.ease,
          opacity: _isTapped? 0.7 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: AppSize.articlesFilterOverlayIsForBeginnerCheckboxPadding, 
                child: SizedBox(
                  width: AppSize.articlesFilterOverlayIsForeBeginnerCheckboxSize, 
                  height: AppSize.articlesFilterOverlayIsForeBeginnerCheckboxSize, 
                  child: Checkbox(
                    value: widget.isForBeginner, 
                    onChanged: (value) => widget.onIsForBeginnerClick(),
                    splashRadius: 0,
                    activeColor: AppTheme.of(context).articlesFilterOverlayIsForBeginnerCheckboxCheckFillActiveColor,
                    checkColor: AppTheme.of(context).articlesFilterOverlayIsForBeginnerCheckboxCheckColor,
                    side: BorderSide(
                      color: AppTheme.of(context).articlesFilterOverlayIsForBeginnerCheckboxColor,
                      width: AppSize.articlesFilterOverlayIsForeBeginnerCheckboxBorderSize,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSize.articlesFilterOverlayIsForBeginnerCheckboxBorderRadius,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSize.articlesFilterOverlayIsForBeginnerCheckboxAndTextSeparatorSize),
              Text(
                AppLocalizations.of(context)!.forBeginnersText,
                style: AppTheme.of(context).articlesFilterOverlayIsForBeginnerCheckboxTextStyle,
              ),
            ],
          ),
        ),
      ),
    ],
  );

  void _onTapUp(TapUpDetails details) {
    widget.onIsForBeginnerClick();

    setState(() { 
      _isTapped = false;
    });
  }

  void _onTapDown(TapDownDetails details) => setState(() { 
    _isTapped = true;
  });

  void _onTapCancel() => setState(() { 
    _isTapped = false;
  });
}