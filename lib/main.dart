import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

/// Um widget que representa o ponto de partida do aplicativo,
/// indicando a utilização do [HomeScreen] como widget
/// inicial.
class MyApp extends StatelessWidget {

  /// Constrói a árvore de widgets, que é composta por
  /// um [MaterialApp] que indica como [home] o widget
  /// [HomeScreen]
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universe Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
