import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru')
  ];

  /// No description provided for @estimateText.
  ///
  /// In ru, this message translates to:
  /// **'Оценить'**
  String get estimateText;

  /// No description provided for @weCouldNotFindPostsText.
  ///
  /// In ru, this message translates to:
  /// **'У нас не получилось найти посты по вашим тегам, уменьшите их количество или сбросьте фильтр.'**
  String get weCouldNotFindPostsText;

  /// No description provided for @orFindInOurTelegramChannelsText.
  ///
  /// In ru, this message translates to:
  /// **'Или поищите в наших Telegram-каналах:'**
  String get orFindInOurTelegramChannelsText;

  /// No description provided for @readUsInTelegramText.
  ///
  /// In ru, this message translates to:
  /// **'Читать нас в Telegram'**
  String get readUsInTelegramText;

  /// No description provided for @newText.
  ///
  /// In ru, this message translates to:
  /// **'Новое'**
  String get newText;

  /// No description provided for @hotText.
  ///
  /// In ru, this message translates to:
  /// **'Горячее'**
  String get hotText;

  /// No description provided for @topOfWeekText.
  ///
  /// In ru, this message translates to:
  /// **'Лучшее за неделю'**
  String get topOfWeekText;

  /// No description provided for @topOfMonthText.
  ///
  /// In ru, this message translates to:
  /// **'Лучшее за месяц'**
  String get topOfMonthText;

  /// No description provided for @topOfTopText.
  ///
  /// In ru, this message translates to:
  /// **'Лучшее за все время'**
  String get topOfTopText;

  /// No description provided for @filterText.
  ///
  /// In ru, this message translates to:
  /// **'Фильтр'**
  String get filterText;

  /// No description provided for @cleanOutText.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get cleanOutText;

  /// No description provided for @applyText.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get applyText;

  /// No description provided for @rubricsText.
  ///
  /// In ru, this message translates to:
  /// **'Рубрики'**
  String get rubricsText;

  /// No description provided for @forBeginnersText.
  ///
  /// In ru, this message translates to:
  /// **'Для начинающих'**
  String get forBeginnersText;

  /// No description provided for @languagesText.
  ///
  /// In ru, this message translates to:
  /// **'Языки'**
  String get languagesText;

  /// No description provided for @themesText.
  ///
  /// In ru, this message translates to:
  /// **'Темы'**
  String get themesText;

  /// No description provided for @allSiteText.
  ///
  /// In ru, this message translates to:
  /// **'Весь сайт'**
  String get allSiteText;

  /// No description provided for @stubyPlansText.
  ///
  /// In ru, this message translates to:
  /// **'Планы обучения'**
  String get stubyPlansText;

  /// No description provided for @tasksText.
  ///
  /// In ru, this message translates to:
  /// **'Задачки'**
  String get tasksText;

  /// No description provided for @quizzesText.
  ///
  /// In ru, this message translates to:
  /// **'Викторины'**
  String get quizzesText;

  /// No description provided for @booksText.
  ///
  /// In ru, this message translates to:
  /// **'Книги'**
  String get booksText;

  /// No description provided for @videoText.
  ///
  /// In ru, this message translates to:
  /// **'Видео'**
  String get videoText;

  /// No description provided for @shortAboutMainText.
  ///
  /// In ru, this message translates to:
  /// **'Коротко о главном'**
  String get shortAboutMainText;

  /// No description provided for @answersOfExpertsText.
  ///
  /// In ru, this message translates to:
  /// **'Ответы экспертов'**
  String get answersOfExpertsText;

  /// No description provided for @articlesText.
  ///
  /// In ru, this message translates to:
  /// **'Статьи'**
  String get articlesText;

  /// No description provided for @translationsText.
  ///
  /// In ru, this message translates to:
  /// **'Переводы'**
  String get translationsText;

  /// No description provided for @selectionsText.
  ///
  /// In ru, this message translates to:
  /// **'Подборки'**
  String get selectionsText;

  /// No description provided for @humorText.
  ///
  /// In ru, this message translates to:
  /// **'Юмор'**
  String get humorText;

  /// No description provided for @interviewText0.
  ///
  /// In ru, this message translates to:
  /// **'Интервью'**
  String get interviewText0;

  /// No description provided for @pythonText.
  ///
  /// In ru, this message translates to:
  /// **'Python'**
  String get pythonText;

  /// No description provided for @javaText.
  ///
  /// In ru, this message translates to:
  /// **'Java'**
  String get javaText;

  /// No description provided for @cPlusPlusText.
  ///
  /// In ru, this message translates to:
  /// **'C++'**
  String get cPlusPlusText;

  /// No description provided for @cSharpText.
  ///
  /// In ru, this message translates to:
  /// **'C#'**
  String get cSharpText;

  /// No description provided for @javaScriptText.
  ///
  /// In ru, this message translates to:
  /// **'JavaScript'**
  String get javaScriptText;

  /// No description provided for @cssText.
  ///
  /// In ru, this message translates to:
  /// **'CSS'**
  String get cssText;

  /// No description provided for @webAssemblyText.
  ///
  /// In ru, this message translates to:
  /// **'WebAssembly'**
  String get webAssemblyText;

  /// No description provided for @reactText.
  ///
  /// In ru, this message translates to:
  /// **'React'**
  String get reactText;

  /// No description provided for @phpText.
  ///
  /// In ru, this message translates to:
  /// **'PHP'**
  String get phpText;

  /// No description provided for @nodeJsText.
  ///
  /// In ru, this message translates to:
  /// **'Node.js'**
  String get nodeJsText;

  /// No description provided for @sqlText.
  ///
  /// In ru, this message translates to:
  /// **'SQL'**
  String get sqlText;

  /// No description provided for @mySqlText.
  ///
  /// In ru, this message translates to:
  /// **'MySQL'**
  String get mySqlText;

  /// No description provided for @golangText.
  ///
  /// In ru, this message translates to:
  /// **'Golang'**
  String get golangText;

  /// No description provided for @dockerText.
  ///
  /// In ru, this message translates to:
  /// **'Docker'**
  String get dockerText;

  /// No description provided for @swiftText.
  ///
  /// In ru, this message translates to:
  /// **'Swift'**
  String get swiftText;

  /// No description provided for @djangoText.
  ///
  /// In ru, this message translates to:
  /// **'Django'**
  String get djangoText;

  /// No description provided for @dotNetText.
  ///
  /// In ru, this message translates to:
  /// **'.NET'**
  String get dotNetText;

  /// No description provided for @perlText.
  ///
  /// In ru, this message translates to:
  /// **'Perl'**
  String get perlText;

  /// No description provided for @objectiveCText.
  ///
  /// In ru, this message translates to:
  /// **'Objective-C'**
  String get objectiveCText;

  /// No description provided for @rLanguageText.
  ///
  /// In ru, this message translates to:
  /// **'Язык R'**
  String get rLanguageText;

  /// No description provided for @assemblerLanguageText.
  ///
  /// In ru, this message translates to:
  /// **'Язык ассемблера'**
  String get assemblerLanguageText;

  /// No description provided for @cLanguageText.
  ///
  /// In ru, this message translates to:
  /// **'Язык Си'**
  String get cLanguageText;

  /// No description provided for @algorithmsAndDataStructuresText.
  ///
  /// In ru, this message translates to:
  /// **'Алгоритмы и структуры данных'**
  String get algorithmsAndDataStructuresText;

  /// No description provided for @designPatternsText.
  ///
  /// In ru, this message translates to:
  /// **'Паттерны проектирования'**
  String get designPatternsText;

  /// No description provided for @interviewText1.
  ///
  /// In ru, this message translates to:
  /// **'Собеседование'**
  String get interviewText1;

  /// No description provided for @machineLearningText.
  ///
  /// In ru, this message translates to:
  /// **'Машинное обучение'**
  String get machineLearningText;

  /// No description provided for @developmentMethodologiesText.
  ///
  /// In ru, this message translates to:
  /// **'Методологии разработки'**
  String get developmentMethodologiesText;

  /// No description provided for @neuralNetworksText.
  ///
  /// In ru, this message translates to:
  /// **'Нейронные сети'**
  String get neuralNetworksText;

  /// No description provided for @artificialIntelligenceText.
  ///
  /// In ru, this message translates to:
  /// **'Искуственный интеллект'**
  String get artificialIntelligenceText;

  /// No description provided for @designOfInterfacesAndUxText.
  ///
  /// In ru, this message translates to:
  /// **'Дизайн интерфейсов и UX'**
  String get designOfInterfacesAndUxText;

  /// No description provided for @dataScienceText.
  ///
  /// In ru, this message translates to:
  /// **'Data Science'**
  String get dataScienceText;

  /// No description provided for @systemAdministrationText.
  ///
  /// In ru, this message translates to:
  /// **'Системное администрирование'**
  String get systemAdministrationText;

  /// No description provided for @webDevelopmentText.
  ///
  /// In ru, this message translates to:
  /// **'Веб-разработка'**
  String get webDevelopmentText;

  /// No description provided for @gameDevelopmentText.
  ///
  /// In ru, this message translates to:
  /// **'Разработка игр'**
  String get gameDevelopmentText;

  /// No description provided for @databasesText.
  ///
  /// In ru, this message translates to:
  /// **'Базы данных'**
  String get databasesText;

  /// No description provided for @mobileDevelopmentText.
  ///
  /// In ru, this message translates to:
  /// **'Мобильная разработка'**
  String get mobileDevelopmentText;

  /// No description provided for @botsText.
  ///
  /// In ru, this message translates to:
  /// **'Боты'**
  String get botsText;

  /// No description provided for @advicesText.
  ///
  /// In ru, this message translates to:
  /// **'Советы'**
  String get advicesText;

  /// No description provided for @programmingStudyText.
  ///
  /// In ru, this message translates to:
  /// **'Обучение программированию'**
  String get programmingStudyText;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
