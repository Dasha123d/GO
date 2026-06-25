import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';

class ArticleDescriptionWidget extends StatelessWidget {
  final String text;
  final bool isInvertetStyle;

  const ArticleDescriptionWidget({
    required this.text,
    required this.isInvertetStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: isInvertetStyle
      ? AppTheme.of(context).articleDescriptionInvertedTextStyle
      : AppTheme.of(context).articleDescriptionTextStyle,
  );
}
