import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/universe_data.dart';

/// Tela de login
class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var auth = context.read<LoggedUser>();
    var explored = context.watch<ExploredPlanets>();
    var username = null;
    var password = null;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Explore!',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Para iniciar a exploração, forneça seu nome de usuário e senha'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nome de usuário',
                  ),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Senha',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  child: Text('ENTRAR'),
                  onPressed: () {
                    auth.signIn(username, password);
                    if (auth.username != null) {
                      explored.removeAll();
                      Navigator.pushReplacementNamed(context, '/planets');
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Atenção!'),
                            content:
                                Text('Forneça as credenciais corretamente.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('FECHAR'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
