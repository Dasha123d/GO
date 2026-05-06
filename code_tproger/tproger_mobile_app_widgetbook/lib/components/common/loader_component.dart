import 'package:flutter/material.dart';
import 'package:tproger_mobile_app/src/widgets/common/loader_widget.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buildLoaderComponent(BuildContext context) => WidgetbookComponent(
  name: 'Loader',
  useCases: [
    WidgetbookUseCase(
      name: 'Custom', 
      builder: (context) => Center(
        child: LoaderWidget(
          isActive: context.knobs.boolean(
            label: 'Is active',
            initialValue: true,
          ),
        ),
      ),
    ),
  ],
);