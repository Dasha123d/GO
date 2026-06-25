import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';

class ActiveIndicatorWidget extends StatelessWidget {
  const ActiveIndicatorWidget({ super.key });

  @override
  Widget build(BuildContext context) => Container(
    width: AppSize.articlesFiltersActiveIndicatorSize,
    height: AppSize.articlesFiltersActiveIndicatorSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppTheme.of(context).articlesFiltersAcitveIndicatorColor,
    ),
  );
}