enum SortType {
  original,
  az,
  za,
}

class WatchlistState {
  final List<String> items;
  final SortType sort;

  WatchlistState({required this.items, required this.sort});

  WatchlistState copyWith({
    List<String>? items,
    SortType? sort,
  }) {
    return WatchlistState(
      items: items ?? this.items,
      sort: sort ?? this.sort,
    );
  }
}