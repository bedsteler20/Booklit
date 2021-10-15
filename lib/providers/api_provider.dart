// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit_api/plexlit_api.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/model/exeptions.dart';
import 'package:plexlit/storage.dart';

class ApiProvider implements ChangeNotifier {
  static final value = ValueNotifier<PlexlitApiClient?>(null);

  ApiProvider([PlexlitApiClient? _initialValue]) {
    value.value = _initialValue;
  }

  static PlexlitApiClient get server {
    if (value.value == null) throw PlexlitExceptions.noApiClientFound;

    return value.value!;
  }

  bool get hasClient => value.value != null;

  static void connect(PlexlitApiClient? i, {bool save = true}) {
    value.value = i;
    if (i != null && save) Storage.saveClient(i);
    value.notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) => value.addListener(listener);

  @override
  dispose() => value.dispose();

  @override
  void notifyListeners() => value.notifyListeners();
  @override
  void removeListener(VoidCallback listener) => value.removeListener(listener);

  @override
  bool get hasListeners => value.hasListeners;
}
