import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_header/articles_sort/articles_sort_button_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_header/articles_sort/articles_sort_menu_item_widget.dart';

class ArticlesSortWidget extends StatefulWidget {
  final ArticlesSortType type;
  final VoidFunctionArticlesSortType onSelect;

  const ArticlesSortWidget({
    required this.type,
    required this.onSelect,
    super.key,
  });

  @override
  State<ArticlesSortWidget> createState() => _ArticlesSortWidgetState();
}

class _ArticlesSortWidgetState extends State<ArticlesSortWidget> {
  var _isOpened = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final dropdownWidth = MediaQuery.of(context).size.width * 0.6;

      return DropdownButtonHideUnderline(
        child: DropdownButton2<ArticlesSortType>(
          value: widget.type,
          onChanged: _onChanged,
          onMenuStateChange: _onMenuStateChange,
          dropdownElevation: 0,
          buttonElevation: 0,
          itemSplashColor: Colors.transparent,
          itemHighlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          buttonSplashColor: Colors.transparent,
          buttonHighlightColor: Colors.transparent,
          dropdownWidth: dropdownWidth,
          itemPadding: AppSize.articlesSortMenuItemPadding,
          dropdownDecoration: BoxDecoration(
            border: Border.all(
              width: AppSize.articlesSortBorderSize,
              color: AppTheme.of(context).articlesSortBorderColor,
            ),
            borderRadius: AppSize.articlesSortBorderRadius,
            color: AppTheme.of(context).articlesSortColor,
          ),
          dropdownPadding: AppSize.articlesSortMenuPadding,
          customButton: ArticlesSortButtonWidget(
            isOpened: _isOpened,
            type: widget.type,
          ),
          items: [ for (final type in ArticlesSortType.values)
            DropdownMenuItem(
              value: type,
              child: ArticlesSortMenuItemWidget(type: type),
            ),
          ],
        ),
      );
    },
  );

  void _onChanged(ArticlesSortType? selectedType) {
    if (widget.type != selectedType) {
      widget.onSelect(selectedType!);
    }
  }

  void _onMenuStateChange(bool isOpened) => setState(() {
    _isOpened = isOpened;
  });
}