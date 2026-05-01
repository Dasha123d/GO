import 'package:tproger_mobile_app/src/models/actions/action.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';

class ApplyFiltersAction extends Action {
  final FilterData newFilterData;
  final FilterData oldFilterData;

  @override
  List<Object> get props => [newFilterData, oldFilterData];

  const ApplyFiltersAction({
    required this.newFilterData,
    required this.oldFilterData,
  });
}