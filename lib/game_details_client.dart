import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir/model/detail_games_model.dart';

class GameDetailsClient {
  static const String baseUrl = "https://www.freetogame.com/api";

  Future<Map<String, dynamic>> getDetails(int id) async {
    var param = id.toString();
    var response = await http.get(Uri.parse("$baseUrl/game?id=${param}"));
    var jsonData = jsonDecode(response.body);
    var detailGames = DetailGamesModel.fromJson(jsonData);
    return jsonData;
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
