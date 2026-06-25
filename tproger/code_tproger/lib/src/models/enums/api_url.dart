enum ApiUrl {
  articlesCommentCounts('/wp-node/comments/count/posts'),
  articlesBookmarkCounts('/wp-node/bookmark/posts'),
  articlesViewCounts('/wp-node/views/posts'),
  articleReactions('/wp-node/reaction/posts'),
  loadNextArticles('/wp-admin/admin-ajax.php'),
  initial('/');

  final String value;

  const ApiUrl(this.value);

  @override
  String toString() => value;
}
