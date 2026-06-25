import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tproger_mobile_app/src/models/consts/app_color.dart';

part 'app_theme_light.dart';
part 'app_theme_dark.dart';
part 'app_theme_lerp.dart';
part 'app_theme_common.dart';

class AppTheme extends ThemeExtension<AppTheme> {
  final Color articleListEndSleepingCatColor;
  final Color mainBackgroundColor;
  final Color loaderColor;
  final Color articleBackgroundColor;
  final Color articleBorderColor;
  final Color articleViewCountIconColor;
  final Color articleViewCountIconInvertedColor;
  final Color articleReactionsBackgroundColor;
  final Color articleReactionsBorderColor;
  final Color articleReactionBorderColor;
  final Color readUsTelegramButtonColor;
  final Color readUsTelegramButtonBorderColor;
  final Color readUsTelegramButtonIconColor;
  final Color articlesSortColor;
  final Color articlesSortBorderColor;
  final Color articlesFilterOverlayCloseButtonIconColor;
  final Color articlesFilterOverlayApplyButtonColor;
  final Color articlesFilterOverlayIsForBeginnerCheckboxColor;
  final Color articlesFilterOverlayColor;
  final Color articlesFilterOverlayCleanOutButtonIconColor;
  final Color articlesFilterButtonColor;
  final Color articlesFilterButtonBorderColor;
  final Color articlesFilterOverlayCleanOutButtonActiveColor;
  final Color articlesFilterOverlayCleanOutButtonBorderActiveColor;
  final Color articlesFilterOverlayIsForBeginnerCheckboxCheckColor;
  final Color articlesFilterOverlayIsForBeginnerCheckboxCheckFillActiveColor;
  final Color articlesFiltersAcitveIndicatorColor;

  final TextStyle articleAuthorNameTextStyle;
  final TextStyle articleAuthorNameInvertedTextStyle;
  final TextStyle articleTitleTextStyle;
  final TextStyle articleTitleInvertedTextStyle;
  final TextStyle articleViewCountTextStyle;
  final TextStyle articleViewCountInvertedTextStyle;
  final TextStyle articleDescriptionTextStyle;
  final TextStyle articleDescriptionInvertedTextStyle;
  final TextStyle articleFooterButtonTextStyle;
  final TextStyle articleFooterButtonInvertedTextStyle;
  final TextStyle articleFooterButtonActiveTextStyle;
  final TextStyle articleReactionTextStyle;
  final TextStyle articleListEndSleepingCatTextStyle;
  final TextStyle articleListEndTelegramTextStyle;
  final TextStyle articleListEndTelegramLinkTextStyle;
  final TextStyle readUsTelegramButtonTextStyle;
  final TextStyle articlesSortMenuItemTextStyle;
  final TextStyle articlesSortButtonTextStyle;
  final TextStyle articlesFilterOverlayHeaderTitleTextStyle;
  final TextStyle articlesFilterOverlayApplyButtonTextStyle;
  final TextStyle articlesFilterOverlayCleanOutButtonTextStyle;
  final TextStyle articlesFilterOverlayRubricTitleTextStyle;
  final TextStyle articlesFilterOverlayIsForBeginnerCheckboxTextStyle;
  final TextStyle articlesFilterButtonTextStyle;
  final TextStyle articlesFilterButtonActiveTextStyle;

  const AppTheme._({
    required this.articleListEndSleepingCatColor,
    required this.mainBackgroundColor,
    required this.loaderColor,
    required this.articleBackgroundColor,
    required this.articleBorderColor,
    required this.articleViewCountIconColor,
    required this.articleViewCountIconInvertedColor,
    required this.articleReactionsBackgroundColor,
    required this.articleReactionsBorderColor,
    required this.articleReactionBorderColor,
    required this.readUsTelegramButtonColor,
    required this.readUsTelegramButtonBorderColor,
    required this.readUsTelegramButtonIconColor,
    required this.articlesSortColor,
    required this.articlesSortBorderColor,
    required this.articlesFilterOverlayCloseButtonIconColor,
    required this.articlesFilterOverlayApplyButtonColor,
    required this.articlesFilterOverlayIsForBeginnerCheckboxColor,
    required this.articlesFilterOverlayColor,
    required this.articlesFilterOverlayCleanOutButtonIconColor,
    required this.articlesFilterButtonColor,
    required this.articlesFilterButtonBorderColor,
    required this.articlesFilterOverlayCleanOutButtonActiveColor,
    required this.articlesFilterOverlayCleanOutButtonBorderActiveColor,
    required this.articlesFilterOverlayIsForBeginnerCheckboxCheckColor,
    required this.articlesFilterOverlayIsForBeginnerCheckboxCheckFillActiveColor,
    required this.articlesFiltersAcitveIndicatorColor,
    required this.articleAuthorNameTextStyle,
    required this.articleAuthorNameInvertedTextStyle,
    required this.articleTitleTextStyle,
    required this.articleTitleInvertedTextStyle,
    required this.articleViewCountTextStyle,
    required this.articleViewCountInvertedTextStyle,
    required this.articleDescriptionTextStyle,
    required this.articleDescriptionInvertedTextStyle,
    required this.articleFooterButtonTextStyle,
    required this.articleFooterButtonInvertedTextStyle,
    required this.articleFooterButtonActiveTextStyle,
    required this.articleReactionTextStyle,
    required this.articleListEndSleepingCatTextStyle,
    required this.articleListEndTelegramTextStyle,
    required this.articleListEndTelegramLinkTextStyle,
    required this.readUsTelegramButtonTextStyle,
    required this.articlesSortMenuItemTextStyle,
    required this.articlesSortButtonTextStyle,
    required this.articlesFilterOverlayHeaderTitleTextStyle,
    required this.articlesFilterOverlayApplyButtonTextStyle,
    required this.articlesFilterOverlayCleanOutButtonTextStyle,
    required this.articlesFilterOverlayRubricTitleTextStyle,
    required this.articlesFilterOverlayIsForBeginnerCheckboxTextStyle,
    required this.articlesFilterButtonTextStyle,
    required this.articlesFilterButtonActiveTextStyle,
  });

  factory AppTheme.light() => _light; 
  factory AppTheme.dark() => _dark;

  static AppTheme of(BuildContext context) => Theme.of(context).extension<AppTheme>()!;

  @override
  AppTheme copyWith() => throw UnsupportedError('');

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) throw UnimplementedError('');

    return _lerp(this, other, t);
  } 
}
