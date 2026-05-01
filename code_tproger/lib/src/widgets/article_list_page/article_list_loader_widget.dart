import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/widgets/common/loader_widget.dart';

class ArticleListLoaderWidget extends StatelessWidget {
  const ArticleListLoaderWidget({ super.key });

  @override
  Widget build(BuildContext context) => const Center(
    child: LoaderWidget(), 
  );
}
