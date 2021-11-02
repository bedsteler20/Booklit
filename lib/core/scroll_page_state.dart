// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:booklit/booklit.dart';

/// Base State class used for making infant scroll pages
/// The first input type is the [Stateful] widget being implemented
/// The second input type is the type of data that is being fetched
abstract class ScrollPageState<W extends StatefulWidget, T> extends State<W> {
  final ScrollController scrollController = ScrollController();

  @nonVirtual
  Object? error;

  /// Used to trick [fetchData] into thinking thare is 0 [itemsFetched] while refreshing data
  bool _isRefreshing = false;

  /// used to prevent fetching data when scroll controllor event fires
  /// and data is already being fetched
  bool _isFetchingData = false;

  /// The max amount of items that will be returned bu [fetchData]
  int get querySize;

  /// The var containing all fetched items. Should
  /// be used somewhere in [build] method
  List<T> items = [];

  /// The count of items fetched
  /// use this instead of [items.length]
  @nonVirtual
  int get itemsFetched => _isRefreshing ? 0 : items.length;

  /// Indicates that all items have been fetched
  /// Stops further scrolling from calling [fetchData]
  bool _isComplete = false;

  /// set to true after first call of [fetchData] in [initState]
  bool hasInitialItems = false;

  /// should fetch data it based on [itemsFetched]
  /// returned value will be added to [items]
  Future<List<T>> fetchData();

  /// Reteaches all data
  Future<void> refreshData() async {
    _isFetchingData = true;
    _isRefreshing = true;

    final fetched = await fetchData();

    _isComplete = fetched.length < querySize;
    _isRefreshing = false;
    _isRefreshing = false;

    setState(() => items.addAll(fetched));
  }

  @override
  void initState() {
    super.initState();
    // Get initial items
    Future(() async {
      try {
        _isFetchingData = true;
        final fetched = await fetchData();

        _isComplete = fetched.length < querySize;
        hasInitialItems = true;
        _isFetchingData = false;

        setState(() => items.addAll(fetched));
      } catch (e) {
        error = e;
        setState(() {});
      }
    });

    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 100 >= scrollController.position.maxScrollExtent) {
          if (!_isFetchingData && !_isComplete) {
            _isFetchingData = true;
            Future(() async {
              try {
                final fetched = await fetchData();

                _isComplete = fetched.length < querySize;
                _isFetchingData = false;

                setState(() => items.addAll(fetched));
              } catch (e) {
                error = e;
                setState(() {});
              }
            });
          }
        }
      },
    );
  }
}
