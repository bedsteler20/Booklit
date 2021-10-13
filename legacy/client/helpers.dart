import 'package:plexlit/service/plex_conection.dart';

Uri makePlexUri(String path, Plex connection) {
  return Uri.parse(connection.dio.options.baseUrl + path + "?X-Plex-Client-Identifier=${connection.clientId}&X-Plex-Token=${connection.token}");
}
