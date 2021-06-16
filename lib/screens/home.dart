import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/planetas_explorados.dart';
import 'package:universe_explorer/screens/login.dart';

/// Um widget que representa a tela inicial (home)
/// que apresenta uma imagem de fundo, um texto com
/// o nome do aplicativo e um botão para prosseguir
/// para a tela [LoginScreen].
class HomeScreen extends StatelessWidget {
  /// Constrói a árvore de widgets, que é composta por um
  /// [Container] que utiliza uma imagem de fundo e três filhos:
  /// - o [Text] que apresenta o título do aplicativo
  /// - o [SizedBox] que representa o espaçamento entre o título o botão seguinte
  /// - o [ElevatedButton] que representa o botão que navega para a próxima tela
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/home.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Universe Explorer',
            style: TextStyle(
              color: Colors.white54,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            icon: Icon(
              Icons.arrow_forward_rounded,
            ),
            label: Text('INICIAR'),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
