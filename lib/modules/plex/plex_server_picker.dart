// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit_api/plexlit_api.dart';

// Project imports:
import 'package:plexlit/modules/plex/plex_library_picker.dart';
import 'package:plexlit/routes.dart';
import 'package:plexlit/storage.dart';
import 'package:plexlit/widgets/widgets.dart';

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
      ),
      body: FutureBuilderPlus<List<PlexDevice>>(
        future: PlexApi.findServers(clientId: Storage.clientId, token: token),
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
                    : () => context.to(
                          "/plex/librarys",
                          // arguments: {
                          //   "clientId": clientId,
                          //   "server": selected,
                          //   "token": token,
                          // },
                        ),
              ),
            );
          });
        },
      ),
    );
  }
}
