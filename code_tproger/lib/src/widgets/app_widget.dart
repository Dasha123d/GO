import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tproger_mobile_app/src/widgets/article_list_page/article_list_page_widget.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({ super.key });

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Future<void> dispose() async {
    await GetIt.instance.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const ArticleListPageWidget();
}
