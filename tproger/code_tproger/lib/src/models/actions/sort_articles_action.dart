import 'package:tproger_mobile_app/src/models/actions/action.dart';
import 'package:tproger_mobile_app/src/models/enums/articles_sort_type.dart';

class SortArticlesAction extends Action {
  final ArticlesSortType sortType;

  @override
  List<Object> get props => [sortType];

  const SortArticlesAction(this.sortType);
}