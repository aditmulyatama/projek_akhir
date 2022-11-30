import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir/login_page.dart';
import 'package:projek_akhir/model/games_model.dart';
import 'package:projek_akhir/games_client.dart';
import 'package:projek_akhir/screens/game_details.dart';
import 'package:projek_akhir/useful_widgets.dart';
import 'package:http/http.dart' as http;

class GamesList extends StatefulWidget {
  const GamesList({Key? key}) : super(key: key);

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  String? query;
  String? genreFilter;
  final GamesListClient _gamesList = GamesListClient();
  Uri url = Uri.parse(
      "https://belajarfirebase-b3d4f-default-rtdb.asia-southeast1.firebasedatabase.app/favorites.json");
  // late Future<List<Games>> games;

  @override
  void initState() {
    // Agent list
    // games = _gamesList.getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Games List"),
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
      body: FutureBuilder(
        future: _gamesList.getGames(),
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
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(List<Games> games) {
    // Games search
    if (query != null) {
      games = games
          .where((element) =>
              element.title!.toLowerCase().contains(query!.toLowerCase()))
          .toList();
    }

// Games genre filter
    if (genreFilter != null) {
      if (genreFilter != "All") {
        games = games
            .where((element) => element.genre!
                .toLowerCase()
                .contains(genreFilter!.toLowerCase()))
            .toList();
      }
    }

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
      // print(uniqueGenre[i].genre);
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
                          http
                              .post(url, body: jsonEncode(games[i]))
                              .then((value) {
                            showNotification(
                                context,
                                "Berhasil menambahkan ${games[i].title} ke favorite",
                                false);
                          });
                        },
                        icon: Icon(Icons.bookmark_add),
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
