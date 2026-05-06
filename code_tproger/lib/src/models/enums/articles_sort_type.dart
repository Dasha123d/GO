enum ArticlesSortType {
  fresh('new'),
  hot('hot'),
  topOfWeek('week'),
  topOfMonth('month'),
  topOfTop('ever');

  final String value;

  const ArticlesSortType(this.value);

  static String staticToString(ArticlesSortType type) => type.value;

  @override
  String toString() => value;
}