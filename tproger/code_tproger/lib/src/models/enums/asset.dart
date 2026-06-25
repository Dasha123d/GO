enum Asset {
  defaultAvatar('images/default_avatar.png'),
  cross('images/cross.svg'),
  trash('images/trash.svg'),
  arrowUp('images/arrow_up.svg'),
  sleepingCat('images/sleeping_cat.svg'),
  telegram0('images/telegram0.svg'),
  telegram1('images/telegram1.svg'),
  eye('images/eye.svg'),
  bookmark('images/bookmark.svg'),
  comment('images/comment.svg'),
  angry('images/angry.svg'),
  laugh('images/laugh.svg'),
  think('images/think.svg'),
  like('images/like.svg'),
  surprise('images/surprise.svg');

  static const package = 'tproger_mobile_app_assets';

  final String value;

  const Asset(this.value);

  @override
  String toString() => value;
}