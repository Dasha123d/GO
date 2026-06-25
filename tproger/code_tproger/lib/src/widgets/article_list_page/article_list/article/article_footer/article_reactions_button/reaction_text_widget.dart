import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';

class ReactionTextWidget extends StatelessWidget {
  final String text;

  const ReactionTextWidget({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTheme.of(context).articleReactionTextStyle,
  );
}