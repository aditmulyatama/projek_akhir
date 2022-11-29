import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:projek_akhir/favorites_client.dart';

import '../games_client.dart';
import '../login_page.dart';
import '../model/games_model.dart';
import '../useful_widgets.dart';
import 'game_details.dart';

class FavoriteScreens extends StatefulWidget {
  const FavoriteScreens({super.key});

  @override
  State<FavoriteScreens> createState() => _FavoriteScreensState();
}

class _FavoriteScreensState extends State<FavoriteScreens> {
  String? query;
  String? key;
  int? length;
  String? genreFilter;
  final GamesListClient _gamesList = GamesListClient();
  final FavoritesGamesClient _favClient = FavoritesGamesClient();
  // late Future<List<Games>> games;

  @override
  void initState() {
    length = 0;
    // Agent list
    // games = _gamesList.getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Favorites games"),
          backgroundColor: Colors.black54,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  showNotification(context, "Sign Out Success", false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                });
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ]),
      body: SafeArea(
        child: FutureBuilder(
          future: _favClient.getFavorites(
              titleSearch: query, key: key, genreSearch: genreFilter),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              return _buildSuccessSection(snapshot.data!);
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "There is no favorite games",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ]),
    );
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(List<Games> games) {
    List<String> uniqueGenre = [
      "All",
      "Shooter",
      "MMOARPG",
      "ARPG",
      "Strategy",
      "Fighting",
      "Action RPG",
      "Battle Royale",
      "MOBA",
      "Card Game",
      "Sports",
      "MMOFPS",
      "MMO",
      "Racing",
      "Social",
      "Fantasy"
    ];

    print(uniqueGenre.length);
    for (var i = 0; i < uniqueGenre.length; i++) {
      print(uniqueGenre[i]);
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Search games",
                        suffixIcon: Icon(Icons.search)),
                    onChanged: (value) => setState(() {
                          query = value;
                        })),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: DropdownButton(
                    alignment: Alignment.centerLeft,
                    hint: Text("Pilih genre"),
                    value: genreFilter,
                    items: uniqueGenre.map((filter) {
                      var i = 0;

                      print(filter);
                      return DropdownMenuItem(
                        child: Text(filter),
                        value: filter,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        genreFilter = value.toString();
                      });
                    },
                  )),
            ),
          ],
        ),
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: games.length,
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameDetails(
                          id: games[i].id!,
                          title: games[i].title!,
                        );
                      })),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 1000,
                        child: Card(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network("${games[i].thumbnail}"),
                                Text(
                                  '${games[i].title}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.gamepad,
                                      size: 15,
                                    ),
                                    Text('${games[i].genre}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      games[i].platform == 'PC (Windows)'
                                          ? Icons.computer_outlined
                                          : Icons.phone_android,
                                      size: 15,
                                    ),
                                    Flexible(
                                        child: Text('${games[i].platform}')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 15,
                                    ),
                                    Text('${games[i].releaseDate}',
                                        textAlign: TextAlign.end),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          showNotification(
                              context,
                              "Berhasil menghapus ${games[i].title} dari favorite",
                              false);
                          setState(() {
                            key = games[i].key;
                          });
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }
}
