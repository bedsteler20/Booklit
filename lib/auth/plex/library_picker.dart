// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:plexlit/model/model.dart';
import 'package:plexlit/repository/repository.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/widgets/widgets.dart';

class PlexLibraryPicker extends StatelessWidget {
  const PlexLibraryPicker(
      {required this.token, required this.clientId, required this.server, Key? key})
      : super(key: key);

  final String token;
  final PlexDevice server;
  final String clientId;

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(server.name ?? "null"),
      ),
      body: FutureBuilderPlus<List<MediaItem>>(
        future: server.library(token: token, clientId: clientId),
        loading: (ctx) => const Center(child: LoadingWidget()),
        error: (ctx, e) => const Center(child: Text("Error")),
        completed: (context, servers) {
          MediaItem? library;

          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              body: ListView.builder(
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  var item = servers[index];
                  return RadioListTile<MediaItem>(
                    title: Text(item.title),
                    groupValue: library,
                    value: item,
                    onChanged: (v) {
                      if (v != null) setState(() => library = v);
                    },
                  );
                },
              ),
              floatingActionButton: ElevatedButton(
                child: const Text("Done"),
                onPressed: library == null
                    ? null
                    : () {
                        repository.connect(
                          PlexApi(
                            server: server,
                            token: token,
                            library: library!,
                            clientId: clientId,
                          ),
                        );
                        context.to("/");
                      },
              ),
            );
          });
        },
      ),
    );
  }
}
