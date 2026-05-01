import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:collection/collection.dart';

@singleton
class ReactionService {
  int commonCount(List<ReactionData> reactions) => reactions.isEmpty
    ? 0
    : reactions.map((reaction) => reaction.count).sum;

  Asset getIconByReaction(Reaction reaction) {
    switch (reaction) {
      case Reaction.like:
        return Asset.like;
      case Reaction.surprise:
        return Asset.surprise;
      case Reaction.angry:
        return Asset.angry;
      case Reaction.laugh:
        return Asset.laugh;
      case Reaction.think:
        return Asset.think;
    }
  }
}