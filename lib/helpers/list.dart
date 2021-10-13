extension ListExt<E> on List {
  E? get lastOrNull {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }
}
