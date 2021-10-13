import 'package:plexlit_api/plexlit_api.dart';
import 'package:test/test.dart';

void main() async {
  var devices = await PlexApi.findServers(
    clientId: "6yrtyeh6z0iuo48edcp8ofb9",
    token: "owdaU7utu_pYqeM35mYf",
  );

  final plex = PlexApi(
    clientId: "6yrtyeh6z0iuo48edcp8ofb9",
    server: devices.first,
    token: "owdaU7utu_pYqeM35mYf",
    libraryKey: "5",
    appName: "Plexlit Test",
    device: "Dart VM",
    deviceName: "Dart VM",
  );
  
  group('Plex', ()  {
    test('All Books', () async => expect((await plex.getAudiobooks()), isList));
    test('Collections', () async => expect((await plex.getCollections()), isList));

    test('Genres', () async => expect((await plex.getGenres()), isList));

    test('Get audiobook', () async {
      var x = await plex.getAudioBook((await plex.getAudiobooks()).first.id);
      print("object");
    });
  });
}
