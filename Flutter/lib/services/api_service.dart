import 'dart:convert';
import 'package:adigau/models/information_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl =
  //     'https://port-0-aadigauu-ss7z32llwfxpe6k.sel5.cloudtype.app';
  static const String baseUrl =
      'https://port-0-aadigauu-1272llwnq4inr.sel5.cloudtype.app';
  static const String items = 'spots';

  static Future<List<InformationModel>> getInformationsByCategory(
      String category) async {
    List<InformationModel> informationInstance = [];
    final url = Uri.parse('$baseUrl/$items/$category/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> informations = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      for (var information in informations) {
        informationInstance.add(
          InformationModel.fromJson(information),
        );
      }
    }
    return informationInstance;
  }

  static Future<InformationModel> getInformationsByid(int id) async {
    final url = Uri.parse('$baseUrl/$items/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final information = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return InformationModel.fromJson(information);
    }
    throw Error();
  }

  void postIsLiked(int id, bool isLiked) async {
    final url = Uri.parse('$baseUrl/zzim/$id');
    await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'isLiked': isLiked.toString(),
      },
    );
  }
}
