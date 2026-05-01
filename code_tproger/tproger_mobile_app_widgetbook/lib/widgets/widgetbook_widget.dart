import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app_widgetbook/folders/common_folder.dart';
import 'package:tproger_mobile_app/src/models/consts/app_localization.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetbookWidget extends StatelessWidget {
  const WidgetbookWidget({ super.key });

  @override
  Widget build(BuildContext context) => Widgetbook<ThemeData>(
    categories: [
      WidgetbookCategory(
        name: 'All',
        folders: [
          buildCommonFolder(context),
        ],
      ),
    ],
    frames: [
      WidgetbookFrame.defaultFrame(),
      WidgetbookFrame.deviceFrame(),
    ],
    devices: const [
      Apple.iPhoneSE2020,
    ],
    appBuilder: (context, child) => child,
    useCaseBuilder: (context, child) => child,  
    scaffoldBuilder: (context, frame, child) => Scaffold(
      backgroundColor: AppTheme.of(context).mainBackgroundColor,
      body: child,
    ),
    themeBuilder: (context, theme, child) => MaterialApp(
      title: AppLocalization.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      theme: theme,
      home: child,
    ), 
    supportedLocales: AppLocalization.supportedLocales,
    appInfo: AppInfo(
      name: AppLocalization.appTitle,
    ),
    themes: [
      WidgetbookTheme(
        name: 'Light',
        data: ThemeData.light().copyWith(
                extensions: <ThemeExtension<AppTheme>>[AppTheme.light()],
              ),
      ),
      WidgetbookTheme(
        name: 'Dark',
        data: ThemeData.dark().copyWith(
                extensions: <ThemeExtension<AppTheme>>[AppTheme.dark()],
              ),
      ),
    ],
  );
}