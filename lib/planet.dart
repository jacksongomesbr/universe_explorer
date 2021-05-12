import 'package:flutter/material.dart';
import 'universe_data.dart';

/// A definição de tipo da função utilizada como callback quando um [planet]
/// for curtido.
typedef void PlanetLikedCallback(Planet planet);

/// Um widget que apresenta os detalhes de um planeta.
class PlanetDetails extends StatefulWidget {
  PlanetDetails({Key key, this.planet, this.onPlanetLike}) : super(key: key);

  /// O [planet] cujas informações são apresentadas.
  final Planet planet;

  /// A callback do tipo [PlanetLikedCallback] que será chamada
  /// quando o planeta for curtido.
  final PlanetLikedCallback onPlanetLike;

  /// Cria o estado do widget, representado por [_PlanetDetailsState]
  @override
  _PlanetDetailsState createState() => _PlanetDetailsState();
}

/// O estado do widget [PlanetDetails].
class _PlanetDetailsState extends State<PlanetDetails> {
  /// Modifica o atributo [Planet.like] do planeta sendo apresentado
  /// e dispara uma chamada para a callback [onPlanetLike]
  void _likeButtonPressed() {
    setState(() {
      widget.planet.like = !widget.planet.like;
      widget.onPlanetLike(widget.planet);
    });
  }

  /// Determina a cor do ícone do botão conforme o valor do atributo [Planet.like].
  Color _favoriteIconColor() {
    if (widget.planet.like) {
      return Colors.red;
    } else {
      return Colors.white;
    }
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
        title: Text(widget.planet.name),
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
            Image(
              image: AssetImage(
                widget.planet.image,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: _likeButtonPressed,
              icon: Icon(
                Icons.favorite,
                color: _favoriteIconColor(),
              ),
              label: Text('CURTIR'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.planet.description,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
