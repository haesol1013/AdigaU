class AddressModel {
  final String latitude, longitude;

  AddressModel.fromMap(Map<String, dynamic> map)
      : longitude = map['x'],
        latitude = map['y'];
}
