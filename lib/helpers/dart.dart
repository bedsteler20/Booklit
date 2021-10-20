// Dart imports:
import 'dart:io';

extension ListExt<E> on List {
  E? get lastOrNull {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }
}

/// helper function to create a directory if it doesn't
/// exist, sanitize the path and return the path
Future<String> mkdir(String path) async {
  return (await Directory(path.replaceAll(" ", "_").toLowerCase()).create(recursive: true)).path;
}
