// ignore_for_file: non_constant_identifier_names

// Package imports:
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

class AudioBookScreen extends StatelessWidget {
  const AudioBookScreen(this.id, {Key? key, this.offline = false}) : super(key: key);
  final String id;
  final bool offline;

  Widget RatingBuilder(BuildContext context, Audiobook book) {
    return RatingBar.builder(
      initialRating: book.userRating / 2,
      minRating: 0.5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      glow: false,
      itemBuilder: (context, _) => Icon(
        Icons.star_rounded,
        color: context.buttonColor,
      ),
      onRatingUpdate: (x) => context.repository?.rateItem(id, x),
    );
  }

  Widget MoreByAuthorBuilder(BuildContext context, Audiobook book) {
    return FutureBuilderPlus<Author>(
      key: key,
      future: REPOSITORY.data!.getAuthor(book.authorId, limit: 10),
      loading: (_) => const SizedBox(),
      error: (_, __) => const SizedBox(),
      completed: (_, author) {
        return MediaRowWidget(
          onShowMore: () {},
          items: author.books.where((e) => e.id != book.id).toList(),
          title: "More by ${book.author}",
        );
      },
    );
  }

  Widget SummeryBuilder(BuildContext context, Audiobook book) {
    if (book.summary?.isNotEmpty ?? false) {
      return Container(
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
              book.summary! + "\n ",
              maxLines: 6,
              style: context.textTheme.subtitle1!.copyWith(fontSize: 16),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget PlayButtonBuilder(BuildContext context, Audiobook book) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 200,
      child: FloatingActionButton.extended(
        tooltip: "Play",
        extendedPadding: const EdgeInsets.all(20),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text("Play"),
        onPressed: () async {
          // Prefer downloaded version of audiobook
          if (STORAGE.downloadsIndex.keys.contains(book.id)) {
            context.find<AudioProvider>().load(await DOWNLOADS.getAudiobook(book.id));
          } else {
            context.find<AudioProvider>().load(book);
          }
          MINIPLAYER_CONTROLLER.animateToHeight(
            duration: const Duration(milliseconds: 500),
            state: PanelState.MAX,
          );
        },
      ),
    );
  }

  Widget DesktopBuilder(BuildContext context, Audiobook book) {
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
                AspectRatio(
                  aspectRatio: 1,
                  child: ImageWidget(
                    url: book.thumb,
                    height: 600,
                    width: 600,
                  ),
                ),
                PlayButtonBuilder(context, book),
                RatingBuilder(context, book),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ColumnContainer(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.75,
                          fontSize: context.isLandscape ? 32 : null),
                    ),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.caption!.copyWith(fontSize: 16),
                    ),
                    AudiobookInfoCard(book),
                    SummeryBuilder(context, book),
                    MoreByAuthorBuilder(context, book),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget MobileBuilder(BuildContext context, Audiobook book) {
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
              children: [ImageWidget(url: book.thumb)],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.75,
                        fontSize: context.isLandscape ? 32 : null),
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.caption!.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 13),
                  RatingBuilder(context, book),
                ],
              ),
            ),
          ],
        ),
        PlayButtonBuilder(context, book),
        AudiobookInfoCard(book),
        SummeryBuilder(context, book),
        MoreByAuthorBuilder(context, book),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderPlus<Audiobook>(
      future: offline ? DOWNLOADS.getAudiobook(id) : REPOSITORY.data!.getAudioBook(id),
      completed: (ctx, data) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(data.title),
              leading: BackButton(onPressed: context.vRouter.historyBack),
              actions: [
                DownloadButton(data),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Center(
                    child: SizedBox(
                      width: context.width > 1250 ? 1250 : null,
                      child: context.isSmallTablet
                          ? DesktopBuilder(ctx, data)
                          : MobileBuilder(ctx, data),
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

class AudiobookInfoCard extends StatelessWidget {
  const AudiobookInfoCard(this.book, {Key? key}) : super(key: key);

  final Audiobook book;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity.clamp(1, 700),
      padding: const EdgeInsets.only(top: 30),
      child: Card(
        child: RowContainer(
          padding: const EdgeInsets.all(10),
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "RELEASE",
                      style: context.caption!.copyWith(
                        fontSize: 13.75,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      book.releaseDate!.year.toString(),
                      style: context.headline4!.copyWith(
                        fontSize: 28,
                        color: context.bodyText1!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "CHAPTERS",
                      style: context.caption!.copyWith(
                        fontSize: 13.75,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      book.chapters.length.toString(),
                      style: context.headline4!.copyWith(
                        fontSize: 28,
                        color: context.bodyText1!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      "LENGTH",
                      style: context.caption!.copyWith(
                        fontSize: 13.75,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${book.length.inHours} hr",
                      style: context.headline4!.copyWith(
                        fontSize: 28,
                        color: context.bodyText1!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
