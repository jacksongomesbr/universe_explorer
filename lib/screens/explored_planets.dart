import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/planeta.dart';
import 'package:universe_explorer/services/auth_service.dart';

/// Tela dos planetas explorados
class ExploredPlanetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planetas explorados',
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: ExploredPlanetsList(),
              ),
            ),
            Divider(
              height: 4,
              color: Colors.black38,
            ),
            ExploredPlanetsTotal(),
          ],
        ),
      ),
    );
  }
}

/// Lista dos planetas explorados
class ExploredPlanetsList extends StatelessWidget {
  Widget _buildTitle(BuildContext context, DocumentReference planetaReference) {
    Stream planetaStream = FirebaseFirestore.instance
        .collection('planetas')
        .doc(planetaReference.id)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: planetaStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data.data();
          data['id'] = snapshot.data.id;
          Planeta planeta = Planeta.fromJson(data);
          return Text(
            planeta.nome,
            style: Theme.of(context).textTheme.headline6,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var authService = context.read<AuthService>();

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('planetas_explorados')
        .where('usuario', isEqualTo: authService.user.email)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Ocorreu um erro ao obter os dados');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return ListView(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data();
              return ListTile(
                leading: Icon(Icons.done),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () async {
                    await document.reference.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Você desmarcou o planeta como explorado'),
                      ),
                    );
                  },
                ),
                title: _buildTitle(context, data['planeta']),
              );
            }).toList(),
          );
        } else {
          return Text('Ainda não');
        }
      },
    );
  }
}

/// Apresenta uma saudação e o total de planetas explorados.
class ExploredPlanetsTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authService = context.read<AuthService>();

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('planetas_explorados')
        .where('usuario', isEqualTo: authService.user.email)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Ocorreu um erro ao obter os dados.');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${authService.user.displayName}!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Você explorou ${snapshot.data.size} planeta(s)!',
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      TextButton(
                        onPressed: () async {
                          WriteBatch batch = FirebaseFirestore.instance.batch();

                          snapshot.data.docs.forEach((document) {
                            batch.delete(document.reference);
                          });
                          await batch.commit();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Zerou!'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(primary: Colors.deepOrange),
                        child: Text('ZERAR'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return null;
        }
      },
    );
  }
}
