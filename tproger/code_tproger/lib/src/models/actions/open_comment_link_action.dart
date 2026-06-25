import 'package:tproger_mobile_app/src/models/actions/action.dart';

class OpenCommentLinkAction extends Action {
  final String articleLink;

  @override
  List<Object> get props => [articleLink];

  const OpenCommentLinkAction(this.articleLink);
}