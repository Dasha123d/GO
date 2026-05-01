import 'package:tproger_mobile_app/src/models/actions/load_next_articles_action/load_next_articles_base_action.dart';
import 'package:tproger_mobile_app/src/models/article_model.dart';


class LoadNextArticlesSuccessAction extends LoadNextArticlesBaseAction {
  final List<ArticleModel> articles;
  final int pageNumber;

  @override
  List<Object> get props => [articles, pageNumber];
  
  const LoadNextArticlesSuccessAction({
    required this.articles,
    required this.pageNumber,
  });
}