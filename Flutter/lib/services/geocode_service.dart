import 'dart:convert';
import 'package:adigau/models/address_model.dart';
import 'package:adigau/models/geocode_model.dart';
import 'package:adigau/services/api_key.dart';
import 'package:http/http.dart' as http;

class GeocodeService {
  final String baseUrl =
      "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode";
  final Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": ApiKey().clientID, // 개인 클라이언트 아이디
    "X-NCP-APIGW-API-KEY": ApiKey().clientSecret // 개인 시크릿 키
  };

  Future<AddressModel> getGeocode(String address) async {
    final url = Uri.parse('$baseUrl?query=$address');

    final response = await http.get(url, headers: headerss);
    if (response.statusCode == 200) {
      final information = jsonDecode(response.body);
      return AddressModel.fromMap(
          GeocodeModel.fromJson(information).addresses[0]);
    }
    throw Error();
  }
}
