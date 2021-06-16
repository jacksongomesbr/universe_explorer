import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/screens/planets.dart';
import 'package:universe_explorer/screens/explored_planets.dart';
import 'package:universe_explorer/screens/login.dart';
import 'package:universe_explorer/models/planetas_explorados.dart';
import 'package:universe_explorer/common/theme.dart';
import 'package:universe_explorer/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universe_explorer/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

/// Widget principal do aplicativo.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// Estado do widget [MyApp].
///
/// O estado contém uma [Future] do tipo [FirebaseApp].
class _MyAppState extends State<MyApp> {

  /// Esta future é utilizada na inicialização do firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // se o estado da conexão indica que os dados já foram obtidos,
        // ou seja, a inicializaçãodo firebase foi concluída,
        // então apresenta a tela
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => AuthService(),
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
        }
        // se chegar até aqui, retorna um indicador de progresso
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
