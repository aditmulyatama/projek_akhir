import 'package:flutter/material.dart';
import 'package:projek_akhir/model/games_model.dart';
import 'package:projek_akhir/games_client.dart';
import 'package:projek_akhir/screens/game_details.dart';

class GamesList extends StatefulWidget {
  const GamesList({Key? key}) : super(key: key);

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
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
        title: Text("Games List"),
        backgroundColor: Colors.black54,
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
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
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: games.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                          Text('${games[i].platform}'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
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
        });
  }
}
