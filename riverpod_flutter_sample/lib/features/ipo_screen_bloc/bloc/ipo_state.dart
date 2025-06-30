import '../../ipo/data/ipomodel.dart';
import '../../ipo/data/iporesponse.dart';
import 'ipo_event.dart';

abstract class IpoState {}

class IpoInitial extends IpoState {}

class IpoLoading extends IpoState {}

// class IpoLoaded extends IpoState {
//   final IpoResponse ipoResponse;
//
//   IpoLoaded(this.ipoResponse);
// }

class IpoLoaded extends IpoState {
  final IpoResponse ipoResponse;
  final List<IpoModel> filteredList;
  final IpoFilter selectedFilter;

  IpoLoaded({
    required this.ipoResponse,
    required this.filteredList,
    required this.selectedFilter,
  });
}

class IpoError extends IpoState {
  final String message;

  IpoError(this.message);
}
