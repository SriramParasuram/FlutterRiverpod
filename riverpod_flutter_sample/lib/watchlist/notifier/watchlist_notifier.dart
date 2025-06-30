import 'package:flutter_hooks_riverpod_app/constants/app_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/watchlist_state.dart';

class WatchlistNotifier extends StateNotifier<WatchlistState> {
  final List<String> _originalList = AppConstants.watchListItems.values.toList();

  WatchlistNotifier()
      : super(WatchlistState(items: AppConstants.watchListItems.values.toList() , sort: SortType.original));

  void sortBy(SortType type) {
    print("sort button clicked action ? $type");
    List<String> sortedList;
    switch (type) {
      case SortType.az:
        sortedList = [..._originalList]..sort((a, b) => a.compareTo(b));
        break;
      case SortType.za:
        sortedList = [..._originalList]..sort((a, b) => b.compareTo(a));
        break;
      case SortType.original:
      default:
        sortedList = [..._originalList];
    }

    print("sorted list  is $sortedList");
    state = state.copyWith(items: sortedList, sort: type);
  }
}