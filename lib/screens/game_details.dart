import 'package:flutter/material.dart';
import 'package:projek_akhir/model/detail_games_model.dart';
import 'package:projek_akhir/game_details_client.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetails extends StatefulWidget {
  const GameDetails({Key? key, required this.id, required this.title})
      : super(key: key);
  final int id;
  final String title;
  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  final GameDetailsClient _gameDetailsClient = GameDetailsClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details ${widget.title}'),
        backgroundColor: Colors.black54,
      ),
      body: FutureBuilder(
        future: _gameDetailsClient.getDetails(widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            DetailGamesModel games = DetailGamesModel.fromJson(snapshot.data);
            return _buildSuccessSection(games);
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

  Widget _buildSuccessSection(DetailGamesModel games) {
    return ListView(
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    child: Image.network(
                      '${games.screenshots?[index].image}',
                      fit: BoxFit.fill,
                    ),
                  );
                },
                itemCount: games.screenshots?.length,
              ),
            ),
            // Image.network(
            //   '${games.thumbnail}',
            //   fit: BoxFit.fill,
            //   width: MediaQuery.of(context).size.width,
            // ),
            Divider(
              color: Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${games.title}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${games.shortDescription}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Link Games ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(games.gameUrl);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        )),
                    child: Text(
                      "Press Here",
                      style: const TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Genre ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${games.genre}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Platform ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${games.platform}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Publishers ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${games.publisher}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Release Date ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${games.releaseDate}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Minimum Systems Requirements ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "OS : ${games.minimumSystemRequirements?.os}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "Processor : ${games.minimumSystemRequirements?.processor}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "Memory : ${games.minimumSystemRequirements?.memory}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "Graphics : ${games.minimumSystemRequirements?.graphics}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "Graphics : ${games.minimumSystemRequirements?.storage}",
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
    // Expanded(
    //   child: Container(
    //     height: 100,
    //     child: ListView.builder(
    //       scrollDirection: Axis.vertical,
    //       itemBuilder: (context, index) {
    //         return Container(
    //           child: Image.network(
    //             '${games.screenshots?[index].image}',
    //             width: MediaQuery.of(context).size.width,
    //             height: MediaQuery.of(context).size.height / 3,
    //           ),
    //         );
    //       },
    //       itemCount: games.screenshots?.length,
    //     ),
    //   ),
    // ),
  }

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
