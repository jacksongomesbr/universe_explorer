import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe_explorer/planet.dart';
import 'package:universe_explorer/universe_data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Um widget que representa a tela da lista dos planetas.
class PlanetsScreen extends StatelessWidget {
  /// Constrói a árvore de widgets, que é composta por um [PlanetList]
  @override
  Widget build(BuildContext context) {
    return PlanetList();
  }
}

/// Um widget que representa o conteúdo da tela [PlanetsScreen].
class PlanetList extends StatefulWidget {
  PlanetList({Key key}) : super(key: key);

  /// Cria e retorna um [_PlanetListState].
  @override
  _PlanetListState createState() => _PlanetListState();
}

/// O estado do widget [PlanetList].
class _PlanetListState extends State<PlanetList> {
  /// Um [Future] que representa a lista dos planetas.
  Future<List<Planet>> planets;

  /// Inicializa o estado.
  ///
  /// Obtém o valor de [carregarDados] e atribui ao [planets].
  @override
  void initState() {
    super.initState();
    planets = carregarDados();
  }

  /// Obtém o conteúdo do arquivo JSON que contém os dados
  /// dos planetas.
  ///
  /// Retorna um [Future].
  Future<List<Planet>> carregarDados() async {
    // Carrega o conteúdo do arquivo `planetas.json` que está
    // na pasta `assets/dados` e armazena em [response]
    // na forma de uma [String]
    final String response =
    await rootBundle.loadString('assets/dados/planetas.json');

    // Decodifica a resposta na forma de um [Map<String, dynamic>]
    final data = await json.decode(response);

    // Percorre a lista dos items em [data] e adiciona em [items]
    List<Planet> items = [];
    for (var item in data) {
      items.add(Planet.fromJson(item));
    }
    return items;
  }

  /// Define a callback que será executada quando um [planet]
  /// for curtido.
  void _handlePlanetLiked(Planet planet) {
    // O block [setState] é chamado com uma função anônima
    // que não tem conteúdo de forma a garantir que o
    // mecanismo reativo entre em ação para atualizar a árvore
    // de widgets sobre qualquer alteração no estado
    setState(() {});
  }

  /// Identifica e retorna o ícone da seção trailing (direita)
  /// do [ListTile]
  Icon _listTrailingIcon(Planet planet) {
    // Se o [planet] estiver como curtido, retorna o ícone
    // `favorite` na cor [Colors.red], caso contrário,
    // na cor [Colors.grey]
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

  /// Constrói o [ListTile] de cada [planet] para ser utilizado
  /// no [ListView].
  ///
  /// O [ListTile] é configurado para:
  /// - navegar para a tela [PlanetDetails] quando clicado
  /// - apresentar a imagem do planeta no `leading`
  /// - apresentar o nome do planeta em `title`
  /// - apresentar o ícone indicativo de [planet] curtido no `trailing`
  Widget _buildListTile(BuildContext context, Planet planet) {
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

  /// Constrói a árvore do widget.
  ///
  /// A árvore do widget é composta por um [AppBar], cujo `body`
  /// é resultado de um [FutureBuilder] que está associado ao `future`
  /// [planets] e constrói um [ListView] cujos items apresentam
  /// as informações dos planetas definidos no arquivo `planetas.json`.
  ///
  /// O widget apresenta um [CircularProgressIndicator] enquanto
  /// o arquivo `planetas.json` não for carregado, o que, em
  /// ambiente desktop praticamente não surte diferença,
  /// mas o mesmo pode não ocorrer no ambiente web
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Planetas"),
        ),
        body: FutureBuilder<List<Planet>>(
          future: planets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                children: snapshot.data.map((Planet planet) {
                  return _buildListTile(context, planet);
                }).toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
