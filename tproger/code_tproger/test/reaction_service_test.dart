@TestOn('vm')

import 'package:test/test.dart';
import 'package:tproger_mobile_app/src/models/enums/asset.dart';
import 'package:tproger_mobile_app/src/models/enums/reaction.dart';
import 'package:tproger_mobile_app/src/models/reaction_data.dart';
import 'package:tproger_mobile_app/src/services/reaction_service.dart';

void main() {
  final reactionService = ReactionService();

  test('Get icon by reaction', () {
    final likeIcon = reactionService.getIconByReaction(Reaction.like);
    final angryIcon = reactionService.getIconByReaction(Reaction.angry);
    final thinkIcon = reactionService.getIconByReaction(Reaction.think);
    final laughIcon = reactionService.getIconByReaction(Reaction.laugh);
    final surpriseIcon = reactionService.getIconByReaction(Reaction.surprise);

    expect(Asset.like, equals(likeIcon));
    expect(Asset.angry, equals(angryIcon));
    expect(Asset.think, equals(thinkIcon));
    expect(Asset.laugh, equals(laughIcon));
    expect(Asset.surprise, equals(surpriseIcon));
  });

  test('Get common reactions count', () {
    int count;

    count = reactionService.commonCount(const [
      ReactionData(reaction: Reaction.like, count: 0),
      ReactionData(reaction: Reaction.angry, count: 0),
    ]);
    expect(0, equals(count));

    count = reactionService.commonCount([]);
    expect(0, equals(count));

    count = reactionService.commonCount(const [
      ReactionData(reaction: Reaction.like, count: 1),
    ]);
    expect(1, equals(count));

    count = reactionService.commonCount(const [
      ReactionData(reaction: Reaction.like, count: 3),
      ReactionData(reaction: Reaction.angry, count: 1),
      ReactionData(reaction: Reaction.think, count: 2),
    ]);
    expect(6, equals(count));
  });
}