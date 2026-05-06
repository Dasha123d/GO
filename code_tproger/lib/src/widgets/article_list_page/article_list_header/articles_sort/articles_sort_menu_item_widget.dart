import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/services/app_localization_service.dart';

class ArticlesSortMenuItemWidget extends StatelessWidget {
  static final _appLocalizationService = GetIt.instance.get<AppLocalizationService>();

  final ArticlesSortType type;

  const ArticlesSortMenuItemWidget({
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
    _appLocalizationService.getTextByArticlesSortType(type, context),
    style: AppTheme.of(context).articlesSortMenuItemTextStyle,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}