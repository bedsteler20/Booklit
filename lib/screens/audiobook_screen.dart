// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:plexlit/controllers/app_controllor.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/routes.dart';
import 'package:plexlit/service/service.dart';
import 'package:plexlit/widgets/widgets.dart';

class AudioBookScreen extends StatelessWidget {
  const AudioBookScreen(this.id, {Key? key}) : super(key: key);
  final String id;

  Widget layoutWidget(BuildContext context, Audiobook data) {
    if (context.isPortrait) {
      return ColumnContainer(
        padding: const EdgeInsets.only(left: 16, right: 16),
        children: [
          RowContainer(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnContainer(
                padding: const EdgeInsets.only(right: 8),
                width: (context.width * 0.3).clamp(1, context.height * 0.4),
                height: (context.width * 0.3).clamp(1, context.height * 0.4),
                children: [
                  ImageWidget(url: data.thumb),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.75,
                          fontSize: context.isLandscape ? 32 : null),
                    ),
                    Text(
                      data.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.caption!.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 13),
                    RatingBar.builder(
                      itemSize: 24,
                      ignoreGestures: true,
                      initialRating: data.userRating / 2,
                      minRating: 0.5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (x) {},
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: 200,
            child: FloatingActionButton.extended(
              tooltip: "Play",
              extendedPadding: const EdgeInsets.all(20),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text("Play"),
              onPressed: () {
                context.find<AudioPlayerService>().load(data);
                context.find<AppController>().miniplayerController.animateToHeight(
                      duration: const Duration(milliseconds: 200),
                      state: PanelState.MIN,
                    );
              },
            ),
          ),
          if (data.summary?.isNotEmpty ?? false)
            Container(
              width: double.infinity.clamp(1, 700),
              padding: const EdgeInsets.only(top: 30),
              child: Card(
                child: ListTile(
                  isThreeLine: true,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Summery",
                      style: context.headline6?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  subtitle: ExpandText(
                    data.summary! + "\n ",
                    maxLines: 6,
                    style: context.textTheme.subtitle1!.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ),
          FutureBuilderPlus<Author>(
            key: key,
            future: ApiProvider.server.getAuthor(data.authorId, limit: 10),
            loading: (_) => const LoadingWidget(),
            error: (_, __) => const Text("error"),
            completed: (_, author) {
              List<MediaItem> books = [];

              return MediaRowWidget(
                onShowMore: () {},
                items: author.books.where((e) => e.id != data.id).toList(),
                title: "More by ${data.author}",
              );
            },
          )
        ],
      );
    } else {
      return ColumnContainer(
        padding: const EdgeInsets.only(left: 16, right: 16),
        children: [
          RowContainer(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnContainer(
                padding: const EdgeInsets.only(right: 16),
                width: (context.width * 0.3).clamp(1, context.height * 0.4),
                children: [
                  ImageWidget(url: data.thumb),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: 200,
                    child: FloatingActionButton.extended(
                      tooltip: "Play",
                      extendedPadding: const EdgeInsets.all(20),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text("Play"),
                      onPressed: () {
                        context.find<AudioPlayerService>().load(data);
                        context.find<AppController>().miniplayerController.animateToHeight(
                              duration: const Duration(milliseconds: 200),
                              state: PanelState.MIN,
                            );
                      },
                    ),
                  ),
                  RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: data.userRating / 2,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (x) {},
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ColumnContainer(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.75,
                            fontSize: context.isLandscape ? 32 : null),
                      ),
                      Text(
                        data.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.caption!.copyWith(fontSize: 16),
                      ),
                      if (data.summary?.isNotEmpty ?? false)
                        Container(
                          width: double.infinity.clamp(1, 700),
                          padding: const EdgeInsets.only(top: 30),
                          child: Card(
                            child: ListTile(
                              isThreeLine: true,
                              title: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Summery",
                                  style: context.headline6?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              subtitle: ExpandText(
                                data.summary! + "\n ",
                                maxLines: 6,
                                style: context.textTheme.subtitle1!.copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      FutureBuilderPlus<Author>(
                        key: key,
                        future: ApiProvider.server.getAuthor(data.authorId, limit: 10),
                        loading: (_) => const LoadingWidget(),
                        error: (_, __) => const Text("error"),
                        completed: (_, author) {
                          if (author.books.isEmpty) return SizedBox();

                          return Container(
                            width: double.infinity.clamp(1, 700),
                            child: Card(
                              child: MediaRowWidget(
                                onShowMore: () => context.to("/author/${author.id}"),
                                items: author.books.where((e) => e.id != data.id).toList(),
                                title: "More by ${data.author}",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderPlus<Audiobook>(
      future: ApiProvider.server.getAudioBook(id),
      completed: (ctx, data) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(data.title),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Center(
                    child: SizedBox(
                      width: context.width > 1250 ? 1250 : null,
                      child: layoutWidget(ctx, data),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
      error: (ctx, e) {
        return const Text("error");
      },
      loading: (ctx) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
