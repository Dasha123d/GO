import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';

class LoaderWidget extends StatefulWidget {
  final bool isActive;

  const LoaderWidget({ 
    this.isActive = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with SingleTickerProviderStateMixin {
  static const _curve = Cubic(0, 0.5, 0.5, 1);
  static const _duration = Duration(milliseconds: 1200);

  static final _tween1 = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: AppSize.loaderItem1StartHeight, end: AppSize.loaderItemEndHeight)
        .chain(CurveTween(curve: _curve)),
      weight: 50,
    ),
    TweenSequenceItem<double>(
      tween: ConstantTween<double>(AppSize.loaderItemEndHeight),
      weight: 30,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: AppSize.loaderItem3StartHeight, end: AppSize.loaderItem1StartHeight)
        .chain(CurveTween(curve: _curve)),
      weight: 20,
    ),
  ]);

  static final _tween2 = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: AppSize.loaderItem2StartHeight, end: AppSize.loaderItemEndHeight)
        .chain(CurveTween(curve: _curve)),
      weight: 50,
    ),
    TweenSequenceItem<double>(
      tween: ConstantTween<double>(AppSize.loaderItemEndHeight),
      weight: 40,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: AppSize.loaderItem3StartHeight, end: AppSize.loaderItem2StartHeight)
        .chain(CurveTween(curve: _curve)),
      weight: 10,
    ),
  ]);

  static final _tween3 = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: AppSize.loaderItem3StartHeight, end: AppSize.loaderItemEndHeight)
        .chain(CurveTween(curve: _curve)),
      weight: 50,
    ),
    TweenSequenceItem<double>(
      tween: ConstantTween<double>(AppSize.loaderItemEndHeight),
      weight: 50,
    ),
  ]);

  late final AnimationController _controller;
  late final Animation<double> _animation1;
  late final Animation<double> _animation2;
  late final Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )
    ..addListener(() => setState(() {}));

    _animation1 = _tween1.animate(_controller);
    _animation2 = _tween2.animate(_controller);
    _animation3 = _tween3.animate(_controller);

    if (!widget.isActive) {
      return;
    }

    _controller.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        color: AppTheme.of(context).loaderColor,
        width: AppSize.loaderItemWidth,
        height: _animation1.value,
      ),
      const SizedBox(width: AppSize.loaderItemSeparatorSize),
      Container(
        color: AppTheme.of(context).loaderColor,
        width: AppSize.loaderItemWidth,
        height: _animation2.value,
      ),
      const SizedBox(width: AppSize.loaderItemSeparatorSize),
      Container(
        color: AppTheme.of(context).loaderColor,
        width: AppSize.loaderItemWidth,
        height: _animation3.value,
      ),
    ],
  );

  @override
  void didUpdateWidget(LoaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive && !widget.isActive) {
      _controller.reset();
      _controller.stop();
    } else if (!oldWidget.isActive && widget.isActive) {
      _controller.repeat(reverse: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    
    super.dispose();
  }
}
