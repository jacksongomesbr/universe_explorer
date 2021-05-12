import 'package:flutter/material.dart';
import 'universe_data.dart';

typedef void PlanetLikedCallback(Planet planet);

class PlanetDetails extends StatefulWidget {
  PlanetDetails({Key key, this.planet, this.onPlanetLike}) : super(key: key);
  final Planet planet;
  final PlanetLikedCallback onPlanetLike;

  @override
  _PlanetDetailsState createState() => _PlanetDetailsState();
}

class _PlanetDetailsState extends State<PlanetDetails> {
  void _likeButtonPressed() {
    setState(() {
      widget.planet.like = !widget.planet.like;
      widget.onPlanetLike(widget.planet);
    });
  }

  Color _favoriteIconColor() {
    if (widget.planet.like) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

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
              image: AssetImage(widget.planet.image),
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
