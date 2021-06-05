import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:universe_explorer/screens/planets.dart';
import 'package:universe_explorer/screens/explored_planets.dart';
import 'package:universe_explorer/screens/login.dart';
import 'package:universe_explorer/models/universe_data.dart';
import 'package:universe_explorer/common/theme.dart';
import 'package:universe_explorer/screens/home.dart';

void main() {
  runApp(MyApp());
}

/// Um widget que representa o ponto de partida do aplicativo,
/// indicando a utilização do [HomeScreen] como widget
/// inicial.
class MyApp extends StatelessWidget {
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

  /// Constrói a árvore de widgets, que é composta por
  /// um [MaterialApp] que indica como [home] o widget
  /// [HomeScreen]
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Planet>>(
      future: carregarDados(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              Provider(
                create: (context) => PlanetCatalog(snapshot.data),
              ),
              ChangeNotifierProvider(
                create: (context) => ExploredPlanets(),
              ),
              ChangeNotifierProvider(
                create: (context) => LoggedUser(),
              ),
            ],
            child: MaterialApp(
              title: 'Universe Explorer',
              theme: appTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => HomeScreen(),
                '/login': (context) => LoginScreen(),
                '/planets': (context) => PlanetsScreen(),
                '/explored': (context) => ExploredPlanetsScreen(),
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
