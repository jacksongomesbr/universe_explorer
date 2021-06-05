import 'dart:collection';
import 'package:flutter/foundation.dart';



/// A estrutura da classe de dados utilizada no aplicativo para
/// armazenar/representar dados de um planeta.
class Planet {
  /// O identificador do planeta.
  final String id;

  /// O caminho da imagem do planeta (na pasta `assets`)
  final String image;

  /// O nome do planeta.
  final String name;

  /// A descrição do planeta.
  final String description;

  /// A indicação de o planeta ter sido curtido (true) ou não (false).
  bool like;

  Planet(this.id, this.image, this.name, this.description, this.like);

  /// Constrói uma instância de [Planet].
  ///
  /// É fornecido como um método estático e o [json] informado como
  /// parâmetro contém um [Map] com as informações do planeta.
  Planet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        name = json['name'],
        description = json['description'],
        like = json['like'];
}

class PlanetCatalog {
  List<Planet> items = [];
  PlanetCatalog(this.items);
}

class ExploredPlanets extends ChangeNotifier {
  final List<Planet> _planets = [];
  UnmodifiableListView<Planet> get planets => UnmodifiableListView(_planets);

  void add(Planet planet) {
    _planets.add(planet);
    notifyListeners();
  }

  bool contains(Planet planet) {
    return _planets.contains(planet);
  }

  void removeAll() {
    _planets.clear();
    notifyListeners();
  }

  void remove(Planet planet) {
    _planets.remove(planet);
    notifyListeners();
  }
}

class LoggedUser extends ChangeNotifier {
  String _username;
  String _password;

  void clear() {
    _username = null;
    _password = null;
    notifyListeners();
  }

  void signIn(String username, String password) {
    _username = username;
    _password = password;
    notifyListeners();
  }

  String get username => _username;
}
