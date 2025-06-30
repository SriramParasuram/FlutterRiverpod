abstract class IpoEvent {}

class FetchIpoData extends IpoEvent {}

// class FilterIpoData extends IpoEvent {}

enum IpoFilter { active, closed, listed, upcoming, all }

class FilterIpoData extends IpoEvent {
  final IpoFilter filter;
  FilterIpoData(this.filter);
}