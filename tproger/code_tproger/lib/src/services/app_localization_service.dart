import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/l10n/app_localizations.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';

@singleton
class AppLocalizationService {
  String getTextByArticlesSortType(ArticlesSortType type, BuildContext context) {
    switch (type) {
      case ArticlesSortType.fresh:
        return AppLocalizations.of(context)!.newText;
      case ArticlesSortType.hot:
        return AppLocalizations.of(context)!.hotText;
      case ArticlesSortType.topOfMonth:
        return AppLocalizations.of(context)!.topOfMonthText;
      case ArticlesSortType.topOfWeek:
        return AppLocalizations.of(context)!.topOfWeekText;
      case ArticlesSortType.topOfTop:
        return AppLocalizations.of(context)!.topOfTopText;
    }
  }
}