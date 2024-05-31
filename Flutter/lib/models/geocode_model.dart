class GeocodeModel {
  final List addresses;

  GeocodeModel.fromJson(Map<String, dynamic> json)
      : addresses = json['addresses'];
}
