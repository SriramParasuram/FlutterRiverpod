import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ipo/data/ipomodel.dart';
import '../../ipo/domain/ipo_repository.dart';
import 'ipo_event.dart';
import 'ipo_state.dart';

class IpoBloc extends Bloc<IpoEvent, IpoState> {
  final IpoRepository ipoRepository;

  IpoBloc({required this.ipoRepository}) : super(IpoInitial()) {
    on<FetchIpoData>(_onFetchIpoData);
    on<FilterIpoData>(_onFilterIpoData);
  }

  Future<void> _onFetchIpoData(
      FetchIpoData event,
      Emitter<IpoState> emit,
      ) async {
    emit(IpoLoading());

    try {
      final response = await ipoRepository.getIpoDataFromRepository();
      emit(IpoLoaded(
        ipoResponse: response,
        filteredList: response.active,
        selectedFilter: IpoFilter.active,
      ));
    } catch (e) {
      emit(IpoError('Failed to load IPOs: ${e.toString()}'));
    }
  }

  Future<void> _onFilterIpoData(
      FilterIpoData event,
      Emitter<IpoState> emit,
      ) async {
    final currentState = state;
    if (currentState is IpoLoaded) {
      final allData = currentState.ipoResponse;
      List<IpoModel> filtered = [];

      switch (event.filter) {
        case IpoFilter.active:
          filtered = allData.active;
          break;
        case IpoFilter.closed:
          filtered = allData.closed;
          break;
        case IpoFilter.listed:
          filtered = allData.listed;
          break;
        case IpoFilter.upcoming:
          filtered = allData.upcoming;
          break;
        case IpoFilter.all:
          filtered = [
            ...allData.active,
            ...allData.closed,
            ...allData.listed,
            ...allData.upcoming,
          ];
          break;
      }

      emit(IpoLoaded(
        ipoResponse: allData,
        filteredList: filtered,
        selectedFilter: event.filter,
      ));
    }
  }
}