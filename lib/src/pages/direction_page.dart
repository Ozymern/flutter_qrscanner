import 'package:flutter/material.dart';
import 'package:flutter_qrscanner/src/bloc/scan_bloc.dart';
import 'package:flutter_qrscanner/src/models/scans_model.dart';
import 'package:flutter_qrscanner/src/utils/util.dart' as util;

class DirectionPage extends StatelessWidget {
  final scanBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scanBloc.getScans();
    // FutureBuilder se usa para una respuesta única, como tomar una imagen de la cámara, obtener datos una vez desde la plataforma nativa (como recuperar la batería del dispositivo), obtener referencias de archivos, realizar una solicitud http, etc.
    // Por otro lado, StreamBuilderse usa para obtener algunos datos más de una vez, como escuchar la actualización de la ubicación, reproducir música, cronómetro, etc.
    return StreamBuilder<List<ScanModel>>(
        stream: scanBloc.scanStreamHttp,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(
              child: Text('No hay información'),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              //Dismissible desliza de izquierda a derecha un elemento, ideal para eliminar
              itemBuilder: (context, i) => Dismissible(
                    //llave unica que es usada para determinar que item borrar
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.redAccent,
                    ),
                    //onDismissed metodo que se va a llamar una vez que se realice completo el Dismissible
                    onDismissed: (direction) {
                      //elimino por id
                      scanBloc.deleteScan(snapshot.data[i].id);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.http,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(snapshot.data[i].value),
                      subtitle: Text(snapshot.data[i].id.toString()),
                      trailing: Icon(
                        Icons.arrow_downward,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        util.launchScan(snapshot.data[i], context);
                      },
                    ),
                  ),
              itemCount: snapshot.data.length,
            );
          }
        });
  }
}
