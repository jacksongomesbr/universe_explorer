import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe_explorer/planet.dart';
import 'package:universe_explorer/universe_data.dart';

class PlanetsScreen extends StatelessWidget {
  final planets = [
    Planet(
        'mercurio',
        'assets/img/mercurio.jpg',
        'Mercúrio',
        'Mercúrio é o planeta mais próximo ao Sol e o oitavo em tamanho no '
            'sistema solar. A distância média é de 57,9 milhões de '
            'quilômetros do Sol.',
        false),
    Planet(
        'venus',
        'assets/img/venus.png',
        'Vênus',
        'Vênus é o segundo planeta do sistema Solar mais próximo do Sol. '
            'Tem cerca de 800 milhões de anos e além do Sol e da Lua é o '
            'corpo celeste mais brilhante no céu, motivo pelo qual é '
            'conhecido desde a antiguidade.',
        false),
  ];

  @override
  Widget build(BuildContext context) {
    return PlanetList(
      planets: planets,
    );
  }
}

class PlanetList extends StatefulWidget {
  PlanetList({Key key, this.planets}) : super(key: key);

  final List<Planet> planets;

  @override
  _PlanetListState createState() => _PlanetListState();
}

class _PlanetListState extends State<PlanetList> {
  void _handlePlanetLiked(Planet planet) {
    setState(() {
      widget.planets[widget.planets.indexOf(planet)].like = planet.like;
    });
  }

  Icon _listTrailingIcon(Planet planet) {
    print([planet.name, planet.like]);
    if (planet.like) {
      return Icon(
        Icons.favorite,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.favorite,
        color: Colors.grey,
      );
    }
  }

  Widget _buildListTitle(BuildContext context, Planet planet) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanetDetails(
              planet: planet,
              onPlanetLike: _handlePlanetLiked,
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
      trailing: _listTrailingIcon(planet),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Planetas"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: widget.planets.map((Planet planet) {
          return _buildListTitle(context, planet);
        }).toList(),
      ),
    );
  }
}
