import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe_explorer/models/planeta.dart';
import 'package:universe_explorer/models/planetas_explorados.dart';
import 'package:universe_explorer/services/auth_service.dart';

/// Tela de detalhes do planeta
class PlanetDetailsScreen extends StatelessWidget {
  /// O [planet] cujas informações são apresentadas.
  final Planeta planeta;

  const PlanetDetailsScreen({this.planeta, Key key}) : super(key: key);

  Widget _buildExploredButton(BuildContext context) {
    var authService = context.read<AuthService>();
    DocumentReference ref_planeta = FirebaseFirestore.instance
        .collection('planetas')
        .doc(planeta.id);

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('planetas_explorados')
        .where('usuario', isEqualTo: authService.user.email)
        .where('planeta', isEqualTo: ref_planeta)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.size > 0) {
            return ElevatedButton.icon(
              icon: Icon(Icons.place),
              label: Text('EXPLORADO'),
            );
          } else {
            return ElevatedButton.icon(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('planetas_explorados')
                    .add({
                  'usuario': authService.user.email,
                  'planeta': ref_planeta,
                  'data': FieldValue.serverTimestamp()
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Você explorou ${planeta.nome}!'),
                  ),
                );
              },
              icon: Icon(Icons.check),
              label: Text('EXPLOREI'),
            );
          }
        }
        return null;
      },
    );
  }

  /// Constrói a árvore de widgets.
  ///
  /// A árvore de widgets é composta por um [Scaffold], que contém um
  /// [FloatingActionButton] e um [Padding].
  ///
  /// O [FloatingActionButton], ao ser pressionado, inicia uma navegação
  /// para a tela anterior do [Navigator].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planeta.nome),
        actions: [
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () => Navigator.pushNamed(context, '/explored'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(planeta.image_url),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildExploredButton(context),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              planeta.descricao,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
