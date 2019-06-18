import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_qrscanner/src/models/scans_model.dart';

//en un StatelessWidget no puedo tener una propiedad que pueda cambiar de valor, todas deben ser final
class CoordinatesPage extends StatefulWidget {
  @override
  _CoordinatesPageState createState() => _CoordinatesPageState();
}

class _CoordinatesPageState extends State<CoordinatesPage> {
  //Se puede usar un controlador para personalizar el comportamiento de un widget
  final mapController = MapController();

  String typeMap = 'streets';

  @override
  Widget build(BuildContext context) {
    //recibo el geolocation
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                //muevo el mapa al punto del marcador
                mapController.move(scan.getLaLng(), 15);
              })
        ],
      ),
      body: Center(child: _createFlutterMap(scan)),
      floatingActionButton: _createBtnFloat(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
        mapController: mapController,
        options: MapOptions(
          //center, la ubicacion central del mapa
          center: scan.getLaLng(),
          zoom: 15,
          //layers son las capas de informacion
        ),
        layers: [
          //agrego mapa principal
          _createMap(),
          //agrego marcador
          _createMarker(scan)
        ]);
  }

  _createMap() {
    return TileLayerOptions(
//urlTemplate que servidor me va a proveer la informacion del mapa
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        //en additionalOptions enviamos el accdessToken y el id, las cordenadas se enviaron en el scan.getLaLng()
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoib3p5bWVybiIsImEiOiJjangxdWczdjcwN3Q4M3lxc3JwbzlrNWtkIn0.Qx42OLb7LYZCQO8dG0HvJA',
          'id':
              'mapbox.$typeMap' // streets, light, outdoors,satelllite -> los diferentes tipos de mapas
        });
  }

  _createMarker(ScanModel scan) {
//devuelvo un marcador
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLaLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 60.0,
                  color: Theme.of(context).primaryColor,
                ),
              )),
    ]);
  }

  Widget _createBtnFloat(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {});
        //streets, light, outdoors{
        if (typeMap == 'streets') {
          typeMap = 'dark';
        } else if (typeMap == 'dark') {
          typeMap = 'light';
        } else if (typeMap == 'light') {
          typeMap = 'outdoors';
        } else if (typeMap == 'outdoors') {
          typeMap = 'satellite';
        } else {
          typeMap = 'streets';
        }
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
