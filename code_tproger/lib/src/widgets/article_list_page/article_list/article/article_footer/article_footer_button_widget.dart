import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';

class ArticleFooterButtonWidget extends StatefulWidget {
  final Asset icon;
  final int count;
  final bool isInvertetStyle;
  final VoidFunction onClick;

  const ArticleFooterButtonWidget({
    required this.icon,
    required this.count,
    required this.isInvertetStyle,
    required this.onClick,
    super.key,
  });

  @override
  State<ArticleFooterButtonWidget> createState() => _ArticleFooterButtonWidgetState();
}

class _ArticleFooterButtonWidgetState extends State<ArticleFooterButtonWidget> with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 250);

  var _isTapped = false;
  var _isAnimationInitialized = false;

  late final AnimationController _controller = AnimationController(
    duration: _duration,
    vsync: this,
  )..addListener(() => setState(() {}));

  late ColorTween _tween;
  late Animation<Color?> _animation;
  late TextStyle _style;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initStyle();
    _initAnimation();

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Row(
        children: [
          SvgPicture.asset(
            widget.icon.value,
            package: Asset.package,
            width:  AppSize.articleFooterButtonIconSize,
            height: AppSize.articleFooterButtonIconSize,
            color: _animation.value,
          ),
          const SizedBox(width: AppSize.articleFooterButtonIconAndTextSeparatorSize),
          if (widget.count > 0) Text(
            widget.count.toString(),
            style: _style.copyWith(color: _animation.value),
          ),
        ],
      ),
    );
  }

  void _initAnimation() {
    final newBegin = _style.color;
    final end = AppTheme.of(context).articleFooterButtonActiveTextStyle.color;

    if (!_isAnimationInitialized || _tween.begin != newBegin) {
      _tween = ColorTween(
        begin: newBegin,
        end: end,
      );
      _animation = _tween.animate(_controller);

      _isAnimationInitialized = true;
    }
  }

  void _initStyle() {
    var newStyle = AppTheme.of(context).articleFooterButtonTextStyle;
    
    if (_isTapped) {
      newStyle = AppTheme.of(context).articleFooterButtonActiveTextStyle;
    } else if (widget.isInvertetStyle) {
      newStyle = AppTheme.of(context).articleFooterButtonInvertedTextStyle;
    }

    _style = newStyle;
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });

    _controller.forward(from: 1);
  } 

  void _onTapUp(TapUpDetails details) {
    setState(() { 
      _isTapped = false;
    });

    _controller.reverse();

    widget.onClick();
  }

  void _onTapCancel() {
    setState(() { 
      _isTapped = false;
    });

    _controller.reverse();
  }
}
