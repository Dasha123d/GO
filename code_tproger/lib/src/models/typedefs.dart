import 'package:redux/redux.dart';
import 'package:tproger_mobile_app/src/models/app_state/app_state.dart';
import 'package:tproger_mobile_app/src/models/app_state/filter_data.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';

typedef MapIdToCount = Map<int, int>;
typedef MapIdToReactions = Map<int, List<ReactionData>>;
typedef AppStore = Store<AppState>;

typedef VoidFunction = void Function();
typedef VoidFunctionFilterData = void Function(FilterData);
typedef FutureVoidFunction = Future<void> Function();
typedef VoidFunctionString = void Function(String);
typedef DynamicFunctionDynamic = dynamic Function(dynamic);
typedef VoidFunctionArticlesSortType = void Function(ArticlesSortType);