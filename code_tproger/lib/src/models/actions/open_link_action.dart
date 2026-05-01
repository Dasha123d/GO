import 'package:tproger_mobile_app/src/models/actions/action.dart';

class OpenLinkAction extends Action {
  final String link;

  @override
  List<Object> get props => [link];

  const OpenLinkAction(this.link);
}