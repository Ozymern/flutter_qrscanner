import 'dart:async';

import 'package:flutter_qrscanner/src/models/scans_model.dart';

class Validator {
  //creacion de stream transforme, entra cierta informacion y sale informacion diferente en la tuberia
  final validatorGep =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    //handleData si scans tiene informacion, esta se agregara al sink
    handleData: (scans, sink) {
      //filtro para agregar a la lista solamente los que sean de tipo geo
      final geoScans = scans.where((x) => x.type == 'geo').toList();

      sink.add(geoScans);
    },
  );

  //creacion de stream transforme, entra cierta informacion y sale informacion diferente en la tuberia
  final validatorHttp =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    //handleData si scans tiene informacion, esta se agregara al sink
    handleData: (scans, sink) {
      //filtro para agregar a la lista solamente los que sean de tipo http
      final httpScans = scans.where((x) => x.type == 'http').toList();

      sink.add(httpScans);
    },
  );
}
