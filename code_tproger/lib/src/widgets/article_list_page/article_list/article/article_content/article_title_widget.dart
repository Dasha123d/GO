import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';

class ArticleTitleWidget extends StatelessWidget {
  final String text;
  final bool isInvertetStyle;

  const ArticleTitleWidget({
    required this.text,
    required this.isInvertetStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: isInvertetStyle
      ? AppTheme.of(context).articleTitleInvertedTextStyle
      : AppTheme.of(context).articleTitleTextStyle,
  );
}
