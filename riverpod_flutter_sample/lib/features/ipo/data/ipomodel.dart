class IpoModel {
  final String companyName;
  final String iPOInfo;
  final String? listingDate;
  final double? maxPrice;
  final double? minPrice;
  final String? startDate;
  final String status;
  final String symbol;

  IpoModel({
    required this.companyName,
    required this.iPOInfo,
    this.listingDate,
    this.maxPrice,
    this.minPrice,
    this.startDate,
    required this.status,
    required this.symbol,
  });

  factory IpoModel.fromJson(Map<String, dynamic> json) {
    return IpoModel(
      companyName: json['companyName'],
      iPOInfo: json['iPOInfo'],
      listingDate: json['listingDate'],
      maxPrice: json['maxPrice'] ?? 0.0,
      minPrice: json['minPrice'] ?? 0.0,
      startDate: json['startDate'],
      status: json['status'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'iPOInfo': iPOInfo,
      'listingDate': listingDate,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'startDate': startDate,
      'status': status,
      'symbol': symbol,
    };
  }
}
