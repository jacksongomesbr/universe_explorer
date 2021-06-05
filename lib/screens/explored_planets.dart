import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/universe_data.dart';

/// Tela dos planetas explorados
class ExploredPlanetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planetas explorados',
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: ExploredPlanetsList(),
              ),
            ),
            Divider(
              height: 4,
              color: Colors.black38,
            ),
            ExploredPlanetsTotal(),
          ],
        ),
      ),
    );
  }
}

/// Lista dos planetas explorados
class ExploredPlanetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var explored = context.watch<ExploredPlanets>();

    return ListView.builder(
      itemCount: explored.planets.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            explored.remove(explored.planets[index]);
          },
        ),
        title: Text(
          explored.planets[index].name,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}

/// Apresenta uma saudação e o total de planetas explorados.
class ExploredPlanetsTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = context.read<LoggedUser>();
    return Consumer<ExploredPlanets>(
      builder: (context, explored, child) => SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${auth.username}!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Você explorou ${explored.planets.length} planeta(s)!',
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  TextButton(
                    onPressed: () {
                      explored.removeAll();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Zerou!'),
                      ));
                    },
                    style: TextButton.styleFrom(primary: Colors.deepOrange),
                    child: Text('ZERAR'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
