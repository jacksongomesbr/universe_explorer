import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/screens/planet.dart';
import 'package:universe_explorer/models/universe_data.dart';

/// Um widget que representa a tela da lista dos planetas.
class PlanetsScreen extends StatelessWidget {
  /// Constrói o [ListTile] de cada [planet] para ser utilizado
  /// no [ListView].
  ///
  /// O [ListTile] é configurado para:
  /// - navegar para a tela [PlanetDetails] quando clicado
  /// - apresentar a imagem do planeta no `leading`
  /// - apresentar o nome do planeta em `title`
  /// - apresentar o ícone indicativo de [planet] explorado no `trailing`
  Widget _buildListTile(BuildContext context, Planet planet) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanetDetailsScreen(
              planet: planet,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage(
          planet.image,
        ),
      ),
      title: Text(planet.name),
      trailing: _PlanetListExploreButton(planet: planet),
    );
  }

  /// Constrói a árvore do widget.
  ///
  /// Um [Consumer] é utilizado para reconstruir a árvore com base
  /// no [PlanetCatalog].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Planetas"),
        actions: [
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () => Navigator.pushNamed(context, '/explored'),
          ),
        ],
      ),
      body: Consumer<PlanetCatalog>(
        builder: (context, catalog, child) {
          return ListView(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            children: catalog.items.map((Planet planet) {
              return _buildListTile(context, planet);
            }).toList(),
          );
        },
      ),
    );
  }
}

/// O ícone para a lista de planetas.
///
/// Se o planeta já tiver sido explorado, retorna o ícone na cor verde,
/// caso contrário, na cor cinza.
///
/// Este widget utiliza o context.select() para obter atualização
/// dos planetas explorados.
class _PlanetListExploreButton extends StatelessWidget {
  final Planet planet;

  const _PlanetListExploreButton({this.planet, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isExplored = context.select<ExploredPlanets, bool>(
          (explored) => explored.contains(planet),
    );
    if (isExplored) {
      return Icon(
        Icons.place,
        color: Colors.green,
      );
    } else {
      return Icon(
        Icons.place,
        color: Colors.black12,
      );
    }
  }
}
