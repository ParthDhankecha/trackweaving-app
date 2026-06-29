extension MapSeparated<S> on Iterable<S> {
  Iterable<T> mapSeparated<T>(T separator, [T Function(S value)? generator]) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    yield generator?.call(iterator.current) ?? (iterator.current as T);
    while (iterator.moveNext()) {
      yield separator;
      yield generator?.call(iterator.current) ?? (iterator.current as T);
    }
  }

  Iterable<T> mapIndexed<T>(T Function(int index, S value)? toElement) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    int index = 0;
    do {
      yield toElement?.call(index, iterator.current) ?? (iterator.current as T);
      index++;
    } while (iterator.moveNext());
  }
}
