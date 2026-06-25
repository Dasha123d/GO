import 'package:equatable/equatable.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';

class ReactionData extends Equatable {
  final Reaction reaction;
  final int count;

  @override
  List<Object> get props => [reaction, count];

  const ReactionData({
    required this.reaction,
    required this.count,
  });
}