import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/planeta.dart';
import 'package:universe_explorer/screens/planet.dart';
import 'package:universe_explorer/models/planetas_explorados.dart';
import 'package:universe_explorer/services/auth_service.dart';

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
  Widget _buildListTile(BuildContext context, Planeta planeta) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanetDetailsScreen(
              planeta: planeta,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(planeta.image_url),
      ),
      title: Text(planeta.nome),
      trailing: _PlanetListExploreButton(planeta: planeta),
    );
  }

  /// Constrói o botão de logout.
  IconButton _buildLogoutButton(BuildContext context) {
    var authService = context.read<AuthService>();
    if (authService.user != null) {
      return IconButton(
        icon: Icon(Icons.logout),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          authService.logout();
          Navigator.of(context).pushReplacementNamed('/');
        },
      );
    } else {
      return null;
    }
  }

  /// Constrói a árvore do widget.
  ///
  /// Um [StreamBuilder] é utilizado para reconstruir a árvore com base
  /// no conteúdo da coleção "planetas", que é obtida no formato de
  /// [Stream] para lidar com os dados em tempo real.
  @override
  Widget build(BuildContext context) {
    // obtém a stream da coleção "Planetas"
    Stream<QuerySnapshot> planetasStream =
        FirebaseFirestore.instance.collection('planetas').snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Planetas"),
        actions: [
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () => Navigator.pushNamed(context, '/explored'),
          ),
          _buildLogoutButton(context),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: planetasStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Ocorreu um erro. ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data();
                  data['id'] = document.id;
                  Planeta planeta = Planeta.fromJson(data);
                  return _buildListTile(context, planeta);
                }).toList(),
              );
            } else {
              return Center(
                child: Icon(Icons.error),
              );
            }
          }),
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
  final Planeta planeta;

  const _PlanetListExploreButton({this.planeta, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authService = context.read<AuthService>();

    DocumentReference ref_planeta =
    FirebaseFirestore.instance.collection('planetas').doc(planeta.id);

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('planetas_explorados')
        .where('usuario', isEqualTo: authService.user.email)
        .where('planeta', isEqualTo: ref_planeta)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Icon(Icons.error);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            if (snapshot.data.size > 0) {
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
        return null;
      },
    );
  }
}
