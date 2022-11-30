import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir/model/games_model.dart';

class GamesListClient {
  static const String baseUrl = "https://www.freetogame.com/api";

  Future<List<Games>> getGames(
      {String? titleSearch, String? genreSearch}) async {
    var response = await http.get(Uri.parse("$baseUrl/games"));
    var jsonData = jsonDecode(response.body);
    List<Games> games = [];

    for (var element in jsonData) {
      // debugPrint(element.toString());
      games.add(Games.fromJson(element));
    }

    // if (titleSearch != null) {
    //   games = games
    //       .where((element) =>
    //           element.title!.toLowerCase().contains(titleSearch.toLowerCase()))
    //       .toList();
    // }

    // if (genreSearch != null) {
    //   if (genreSearch != "All") {
    //     games = games
    //         .where((element) => element.genre!
    //             .toLowerCase()
    //             .contains(genreSearch.toLowerCase()))
    //         .toList();
    //   }
    // }
    return games;
    // debugPrint(response.body);
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
    // (jsonDecode(response.body)).forEach((element) {
    //   games.add(Games.fromJson(element));
    // });