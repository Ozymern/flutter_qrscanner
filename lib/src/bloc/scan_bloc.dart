import 'dart:async';

import 'package:flutter_qrscanner/src/provider/db_provider.dart';

import 'validator.dart';

//Para usar una mezcla, use la withpalabra clave seguida de uno o más nombres de mezcla:
class ScansBloc with Validator {
  //otra foma de implementar patron singleton
  static ScansBloc _scansBloc = ScansBloc._internal();

  //factory puede retornar una instancia o puede retornar otra cosa
  factory ScansBloc() {
    return _scansBloc;
  }

  ScansBloc._internal() {
    //obtener los scans de la base de datos
    getScans();
  }

  //broadcast para escuchar desde varios lugares
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  //escuchar la informacion  geolocation que fluye dentro del Stream
  Stream<List<ScanModel>> get scanStreamGeo =>
      _scansController.stream.transform(validatorGep);

  //escuchar la informacion  http que fluye dentro del Stream
  Stream<List<ScanModel>> get scanStreamHttp =>
      _scansController.stream.transform(validatorHttp);

  dispose() {
    //?. para verificar que tenga un objeto
    _scansController?.close();
  }

  getScans() async {
    //agrego al flujo de informacion, await ya que devuelve un future, con await espero que se resuelve y devuelva una lista
    _scansController.sink.add(await DBProvider.db.getScansAll());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScans(id);
    //actualizar el controller con nueva informacion de entrada
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    //actualizar el controller con nueva informacion de entrada
    getScans();
  }

  insertScan(ScanModel scanModel) async {
    await DBProvider.db.insertScans(scanModel);
    //actualizar el controller con nueva informacion de entrada
    getScans();
  }
}
