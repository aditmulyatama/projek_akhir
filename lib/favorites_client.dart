import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir/model/games_model.dart';

class FavoritesGamesClient {
  static const String baseUrl =
      "https://belajarfirebase-b3d4f-default-rtdb.asia-southeast1.firebasedatabase.app/favorites.json";

  Future<List<Games>> getFavorites(
      {String? titleSearch, String? key, String? genreSearch}) async {
    List<Games> games = [];

    var response = await http.get(Uri.parse(baseUrl));
    var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonData);
    jsonData.forEach((kunci, value) {
      games.add(Games(
          developer: value['developer'],
          freetogameProfileUrl: value['freetogame_profile_url'],
          gameUrl: value['game_url'],
          genre: value['genre'],
          id: value['id'],
          key: kunci,
          platform: value['platform'],
          publisher: value['publisher'],
          releaseDate: value['release_date'],
          shortDescription: value['short_description'],
          thumbnail: value['thumbnail'],
          title: value['title']));
    });
    if (key != null) {
      Uri url = Uri.parse(
          "https://belajarfirebase-b3d4f-default-rtdb.asia-southeast1.firebasedatabase.app/favorites/${key}.json");
      http.delete(url).then((value) => null);
      games.removeWhere((element) => element.key == key);
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

  Future<void> deleteFavorites(String id) async {
    Uri url = Uri.parse(
        "https://belajarfirebase-b3d4f-default-rtdb.asia-southeast1.firebasedatabase.app/favorites/${id}.json");
    return await http.delete(url).then((value) => null);
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
    // (jsonDecode(response.body)).forEach((element) {
    //   games.add(Games.fromJson(element));
    // });