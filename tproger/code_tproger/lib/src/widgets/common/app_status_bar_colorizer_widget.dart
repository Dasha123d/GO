import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';

class AppStatusBarColorizerWidget extends StatelessWidget {
  final Widget child;

  const AppStatusBarColorizerWidget({ 
    required this.child,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor: AppTheme.of(context).mainBackgroundColor,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark,
    ),
    child: child,
  );
}