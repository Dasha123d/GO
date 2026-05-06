enum ArticleListSelector {
  authorUserName('.user-miniature__username'),
  authorCompanyName('.company-miniature__name'),
  description('.article__excerpt.article__excerpt--icon'),
  imageIcon('.article__icon-image'),
  imageBackground('.article__background-image'),
  imageBackgroundColor('.article__background-icon-image'),
  authorImage('.article__container-author'),
  title('.article__link'),
  article('article');

  final String value;

  const ArticleListSelector(this.value);

  @override
  String toString() => value;
}
