import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir/login_page.dart';
import 'package:projek_akhir/model/games_model.dart';
import 'package:projek_akhir/games_client.dart';
import 'package:projek_akhir/screens/game_details.dart';
import 'package:projek_akhir/useful_widgets.dart';

class GamesList extends StatefulWidget {
  const GamesList({Key? key}) : super(key: key);

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  String? query;
  final GamesListClient _gamesList = GamesListClient();
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
      body: SafeArea(
        child: FutureBuilder(
          future: _gamesList.getGames(titleSearch: query),
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
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(List<Games> games) {
    var seen = Set<String>();
    List<dynamic> uniqueGenre =
        games.where((element) => seen.add(element.genre.toString())).toList();
    print(uniqueGenre.length);
    for (var i = 0; i < uniqueGenre.length; i++) {
      print(uniqueGenre[i].genre);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Search games", suffixIcon: Icon(Icons.search)),
              onChanged: (value) => setState(() {
                    query = value;
                  })),
        ),
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: games.length,
              itemBuilder: (context, i) {
                return InkWell(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                Flexible(child: Text('${games[i].platform}')),
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
                );
              }),
        ),
      ],
    );
  }
}
