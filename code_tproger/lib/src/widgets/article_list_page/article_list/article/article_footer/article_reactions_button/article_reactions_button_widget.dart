import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:overlayment/overlayment.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/services/reaction_service.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions_button/add_reaction_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions_button/reaction_list_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list/article/article_footer/article_reactions_button/reactions_overlay/reactions_overlay_widget.dart';

class ArticleReactionsButtonWidget extends StatefulWidget {
  final List<ReactionData> reactions;

  const ArticleReactionsButtonWidget({ 
    required this.reactions,
    super.key,
  });

  @override
  State<ArticleReactionsButtonWidget> createState() => _ArticleReactionsButtonWidgetState();
}

class _ArticleReactionsButtonWidgetState 
  extends State<ArticleReactionsButtonWidget> 
  with TickerProviderStateMixin
{
  static const _duration = Duration(milliseconds: 250);

  static final _reactionService = GetIt.instance.get<ReactionService>();

  late final _decorationAnimationController = AnimationController(
    duration: _duration,
    vsync: this,
  )..addListener(() => setState(() {}));
  late final _overlayAnimationController = AnimationController(
    duration: _duration,
    vsync: this,
  )..addListener(() => setState(() {}));

  var _isAnimationsInitialized = false;
  var _isReactionsOverlayShown = false;

  late Animation<Decoration> _decorationAnimation;
  late final Animation<double> _overlayAnimation = Tween<double>(
    begin: 0,
    end: AppSize.articleReactionIconSize + 
      AppSize.articleReactionBorderSize * 2 + 
      AppSize.articleReactionsPadding.top + 
      AppSize.articleReactionsPadding.bottom +
      AppSize.articleReactionsBorderSize * 2 +
      AppSize.reactionsOverlayOffset,
  ).animate(_overlayAnimationController);
  
  late Tween<Decoration> _decorationTween;

  int get _commonCount => _reactionService.commonCount(widget.reactions);

  @override
  Widget build(BuildContext context) {
    _initAnimations();

    return OverExpander<void>(
      isClickable: false,
      expand: _isReactionsOverlayShown,
      addInsetsPaddings: false,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(),
      onSelect: _onOverlayHide,
      backgroundSettings: const BackgroundSettings(
        color: Colors.transparent,
        dismissOnClick: true,
      ),
      animation: OverFadeAnimation(
        curve: Curves.ease,
        reverseCurve: Curves.ease,
        durationMilliseconds: _duration.inMilliseconds,
        reverseDurationMilliseconds: _duration.inMilliseconds,
        child: OverScaleAnimation(
          curve: Curves.ease,
          reverseCurve: Curves.ease,
          durationMilliseconds: _duration.inMilliseconds,
          reverseDurationMilliseconds: _duration.inMilliseconds,
        ),
      ),
      expandChild: LimitedBox(
        maxHeight: 0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _overlayAnimation, 
              builder: (context, child) => Positioned(
                bottom: _overlayAnimation.value,
                right: 0,
                child: child!,
              ),
              child: const ReactionsOverlayWidget(),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          decoration: _decorationAnimation.value,
          padding: AppSize.articleReactionsPadding,
          child: (_commonCount == 0) 
            ? const AddReactionWidget() 
            : ReactionListWidget(reactions: widget.reactions),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _decorationAnimationController.dispose();
    _overlayAnimationController.dispose();

    super.dispose();
  }

  void _initAnimations() {
    _initDecorationAnimation();

    _isAnimationsInitialized = true;
  }

  void _initDecorationAnimation() {
    final newBeginTween = BoxDecoration(
      color: AppTheme.of(context).articleReactionsBackgroundColor,
      boxShadow: const [
        BoxShadow(color: Colors.transparent),
      ],
      border: Border.all(
        width: AppSize.articleReactionsBorderSize,
        color: AppTheme.of(context).articleReactionsBorderColor,
      ),
      borderRadius: AppSize.articleReactionsBorderRadius,
    );

    final newEndTweet = BoxDecoration(
      color: AppTheme.of(context).articleReactionsBackgroundColor,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.14),
          offset: Offset(0, 4),
          blurRadius: 9,
        ),
      ],
      border: Border.all(
        width: AppSize.articleReactionsBorderSize,
        color: AppTheme.of(context).articleReactionsBorderColor,
      ),
      borderRadius: AppSize.articleReactionsBorderRadius,
    );

    final isNeedUpdate = !_isAnimationsInitialized ||
      _decorationTween.begin != newBeginTween      ||
      _decorationTween.end   != newEndTweet;
    
    if (isNeedUpdate) {
      _decorationTween = DecorationTween(
        begin: newBeginTween,
        end: newEndTweet,
      );

      _decorationAnimation = _decorationTween.animate(_decorationAnimationController);
    }
  }

  void _onTapDown(TapDownDetails details) => _decorationAnimationController.forward(from: 1);

  void _onTapUp(TapUpDetails details) {
    _decorationAnimationController.reverse();

    setState(() {
      _isReactionsOverlayShown = true;
    });

    _overlayAnimationController.forward();
  }

  void _onTapCancel() => _decorationAnimationController.reverse();

  void _onOverlayHide(void _) => setState(() {
    _isReactionsOverlayShown = false;
  });
}
