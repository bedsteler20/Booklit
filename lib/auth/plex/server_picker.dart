// Package imports:
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class PlexServerPicker extends StatelessWidget {
  const PlexServerPicker({required this.token, required this.clientId, Key? key}) : super(key: key);

  final String token;
  final String clientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Plex Servers"),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilderPlus<List<PlexDevice>>(
        future: PlexRepository.findServers(clientId: clientId, token: token),
        loading: (ctx) => const Center(child: LoadingWidget()),
        error: (ctx, e) => const Center(child: Text("Error")),
        completed: (context, servers) {
          PlexDevice? selected;

          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              body: ListView.builder(
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  var item = servers[index];
                  return RadioListTile<PlexDevice>(
                    title: Text(item.name ?? "Null"),
                    groupValue: selected,
                    value: item,
                    onChanged: (v) {
                      if (v != null) setState(() => selected = v);
                    },
                  );
                },
              ),
              floatingActionButton: ElevatedButton(
                  child: const Text("Next"),
                  onPressed: selected == null
                      ? null
                      : () async {
                          final library = await showDialog<MediaItem?>(
                              context: context,
                              builder: (_) => PlexLibraryPicker(
                                    token: token,
                                    clientId: clientId,
                                    server: selected!,
                                  ));
                          if (library != null) {
                            repository.connect(
                              PlexRepository(
                                  server: selected!,
                                  token: token,
                                  library: library,
                                  clientId: clientId,
                                  id: const Uuid().v4()),
                              setPrimaryClient: true,
                            );

                            context.vRouter.to("/");
                          }
                        }),
            );
          });
        },
      ),
    );
  }
}
