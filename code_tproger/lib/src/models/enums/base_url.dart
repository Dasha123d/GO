enum BaseUrl {
  host(_host),
  base('https://$_host');

  static const _host = 'tproger.ru';

  final String value;

  const BaseUrl(this.value);

  @override
  String toString() => value;
}
