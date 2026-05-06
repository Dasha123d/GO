import 'package:flutter/material.dart';
import 'package:tproger_mobile_app_widgetbook/components/common/loader_component.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookFolder buildCommonFolder(BuildContext context) => WidgetbookFolder(
  name: 'Common',
  widgets: [
    buildLoaderComponent(context),
  ],
);