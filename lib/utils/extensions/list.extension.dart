extension GetValueFromListIfAvailable<T> on List<T> {
  /// [customSearch] will be priority if given
  T? getValue({T? value, bool Function(T element)? customSearch}) {
    if (value == null && customSearch == null) return null;
    final index = indexWhere(customSearch ?? (element) => element == value);
    if (index >= 0) return this[index];
    return null;
  }
}

extension NullableListChecks on List? {
  bool get isEmpty => this?.isEmpty ?? true;
  bool get isNotEmpty => this?.isNotEmpty ?? false;
}
