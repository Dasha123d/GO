enum Reaction {
  angry(1),
  surprise(2),
  think(3),
  laugh(4),
  like(5);

  final int value;

  const Reaction(this.value);

  factory Reaction.fromInt(int value) =>
    values.firstWhere((reaction) => reaction.value == value);

  @override
  String toString() => value.toString();
}
