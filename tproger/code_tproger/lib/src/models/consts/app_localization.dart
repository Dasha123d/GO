import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tproger_mobile_app/l10n/app_localizations.dart';

class AppLocalization {
  static const appTitle = 'Tproger';

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const supportedLocales = [
    Locale('ru'),
  ];
}