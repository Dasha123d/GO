enum Method {
  get('get');

  final String value;

  const Method(this.value);

  @override
  String toString() => value;
}
