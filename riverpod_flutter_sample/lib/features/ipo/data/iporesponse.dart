import 'ipomodel.dart';

class IpoResponse {
  final List<IpoModel> active;
  final List<IpoModel> closed;
  final List<IpoModel> listed;
  final List<IpoModel> upcoming;

  IpoResponse({
    required this.active,
    required this.closed,
    required this.listed,
    required this.upcoming,
  });

  factory IpoResponse.fromJson(Map<String, dynamic> json) {
    return IpoResponse(
      active: List<IpoModel>.from(json['active'].map((e) => IpoModel.fromJson(e))),
      closed: List<IpoModel>.from(json['closed'].map((e) => IpoModel.fromJson(e))),
      listed: List<IpoModel>.from(json['listed'].map((e) => IpoModel.fromJson(e))),
      upcoming: List<IpoModel>.from(json['upcoming'].map((e) => IpoModel.fromJson(e))),
    );
  }
}
