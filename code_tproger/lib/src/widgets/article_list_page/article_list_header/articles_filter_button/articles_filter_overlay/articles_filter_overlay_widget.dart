import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/app_theme/app_theme.dart';
import 'package:tproger_mobile_app/src/models/consts/app_size.dart';
import 'package:tproger_mobile_app/src/models/typedefs.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_header/articles_filter_button/articles_filter_overlay/close_button_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_header/articles_filter_button/articles_filter_overlay/header/header_widget.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_header/articles_filter_button/articles_filter_overlay/rubric_wdget.dart';

class ArticlesFilterOverlayWidget extends StatefulWidget {
  final FilterData filterData;
  final VoidFunctionFilterData onApplyClick;
  final VoidFunction onCleanOutClick;
  final VoidFunction onCloseClick;

  const ArticlesFilterOverlayWidget({
    required this.filterData,
    required this.onApplyClick,
    required this.onCleanOutClick,
    required this.onCloseClick,
    super.key,
  });

  @override
  State<ArticlesFilterOverlayWidget> createState() => _ArticlesFilterOverlayWidgetState();
}

class _ArticlesFilterOverlayWidgetState extends State<ArticlesFilterOverlayWidget> {
  late FilterData newFilterData;

  @override
  void initState() {
    super.initState();

    newFilterData = widget.filterData;
  }

  @override
  void didUpdateWidget(ArticlesFilterOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    newFilterData = widget.filterData;
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppTheme.of(context).articlesFilterOverlayColor,
    ),
    child: SafeArea(
      child: Stack(
        children: [
          Container(
            color: AppTheme.of(context).articlesFilterOverlayColor,
            padding: AppSize.articlesFilterOverlayPadding,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    onApplyClick: () => widget.onApplyClick(newFilterData),
                    onCleanOutClick: widget.onCleanOutClick,
                  ),
                  const SizedBox(height: AppSize.articlesFilterOverlayHeaderAndRubricSeparatorSize),
                  RubricWidget(
                    isForBeginner: newFilterData.isForBeginner,
                    onIsForBeginnerClick: _onIsForBeginnerClick,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CloseButtonWidget(
              onClick: widget.onCloseClick,
            ),
          ),
        ],
      ),
    ),
  );

  void _onIsForBeginnerClick() => setState(() {
    newFilterData = newFilterData.rebuild((b) => b
      ..isForBeginner = !newFilterData.isForBeginner
    );
  });
}