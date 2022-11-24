import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir/model/games_model.dart';

class GamesListClient {
  static const String baseUrl = "https://www.freetogame.com/api";

  Future<List<Games>> getGames() async {
    var response = await http.get(Uri.parse("$baseUrl/games"));
    var jsonData = jsonDecode(response.body);
    List<Games> games = [];

    for (var element in jsonData) {
      // debugPrint(element.toString());
      games.add(Games.fromJson(element));
    }
    // debugPrint(response.body);
    return games;
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
    // (jsonDecode(response.body)).forEach((element) {
    //   games.add(Games.fromJson(element));
    // });