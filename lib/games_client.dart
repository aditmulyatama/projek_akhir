import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projek_akhir/model/games_model.dart';

class GamesListClient {
  static const String baseUrl = "https://www.freetogame.com/api";

  Future<List<Games>> getGames() async {
    var response = await http.get(Uri.parse("$baseUrl/games"));
    List<Games> games = [];
    (jsonDecode(response.body)).forEach((element) {
      games.add(Games.fromJson(element));
    });

    return games;
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
    // for (var g in jsonData) {
    //   Games game = Games(
    //     id: g['id'],
    //     title: g['title'],
    //     thumbnail: g['thumbnail'],
    //     shortDescription: g['short_description'],
    //     gameUrl: g['game_url'],
    //     genre: g['genre'],
    //     platform: g['platform'],
    //     publisher: g['publishers'],
    //     developer: g['developers'],
    //     releaseDate: g['release_date'],
    //     freetogameProfileUrl: g['freetogame_profile_url'],
    //   );
    //   games.add(game);
    // }
