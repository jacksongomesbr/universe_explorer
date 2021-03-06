import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe_explorer/planet.dart';
import 'package:universe_explorer/universe_data.dart';

class PlanetsScreen extends StatelessWidget {
  void planetItemTap(String planet) {}

  final planets = [
    Planet(
        'mercurio',
        'assets/img/mercurio.jpg',
        'Mercúrio',
        'Mercúrio é o planeta mais próximo ao Sol e o oitavo em tamanho no '
            'sistema solar. A distância média é de 57,9 milhões de '
            'quilômetros do Sol.'),
    Planet(
        'venus',
        'assets/img/venus.png',
        'Vênus',
        'Vênus é o segundo planeta do sistema Solar mais próximo do Sol. '
            'Tem cerca de 800 milhões de anos e além do Sol e da Lua é o '
            'corpo celeste mais brilhante no céu, motivo pelo qual é '
            'conhecido desde a antiguidade.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Planetas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/img/mercurio.jpg',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Mercúrio'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlanetScreen(
                              planet: planets[0],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              planets[1].image,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(planets[1].name),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlanetScreen(
                              planet: planets[1],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
