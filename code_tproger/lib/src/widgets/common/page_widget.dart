import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_localization.dart';
import 'package:tproger_mobile_app/src/widgets/common/app_status_bar_colorizer_widget.dart';

abstract class PageWidget extends StatelessWidget {
  const PageWidget({ super.key });

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppLocalization.appTitle,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalization.localizationsDelegates,
    supportedLocales: AppLocalization.supportedLocales,
    theme: ThemeData.light().copyWith(
      extensions: <ThemeExtension<AppTheme>>[AppTheme.light()],
    ),
    darkTheme: ThemeData.dark().copyWith(
      extensions: <ThemeExtension<AppTheme>>[AppTheme.dark()],
    ),
    home: AppStatusBarColorizerWidget(
      child: SafeArea(
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: AppTheme.of(context).mainBackgroundColor,
            body: buildContent(context),
          ),
        ),
      ),
    ),
  );

  Widget buildContent(BuildContext context);
}
