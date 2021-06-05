import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/universe_data.dart';

/// Tela de detalhes do planeta
class PlanetDetailsScreen extends StatelessWidget {
  /// O [planet] cujas informações são apresentadas.
  final Planet planet;

  const PlanetDetailsScreen({this.planet, Key key}) : super(key: key);

  Widget _buildExploredButton(BuildContext context) {
    var isExplored = context.select<ExploredPlanets, bool>(
          (explored) => explored.contains(planet),
    );
    return ElevatedButton.icon(
      onPressed: isExplored
          ? null
          : () {
        var explored = context.read<ExploredPlanets>();
        explored.add(planet);
      },
      icon: isExplored ? Icon(Icons.place) : Icon(Icons.check),
      label: isExplored ? Text('EXPLORADO') : Text('EXPLOREI'),
    );
  }

  /// Constrói a árvore de widgets.
  ///
  /// A árvore de widgets é composta por um [Scaffold], que contém um
  /// [FloatingActionButton] e um [Padding].
  ///
  /// O [FloatingActionButton], ao ser pressionado, inicia uma navegação
  /// para a tela anterior do [Navigator].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planet.name),
        actions: [
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () => Navigator.pushNamed(context, '/explored'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(
                planet.image,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildExploredButton(context),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              planet.description,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
