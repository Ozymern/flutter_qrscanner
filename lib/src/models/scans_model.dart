import 'dart:convert';

import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String type;
  String value;

  ScanModel({
    this.id,
    this.type,
    this.value,
  }) {
    if (this.value.contains("http")) {
      this.type = "http";
    } else {
      this.type = "geo";
    }
  }

  LatLng getLaLng() {
    //geo:-33.55012314316467,-70.62573566874391 corto la palabra geo, lo corto opteniendo la latitud en  la primera posicion y longitud en la segunda
    final latLng = value.substring(4).split(',');
    //convierto a doble
    final lat = double.parse(latLng[0]);
    final lng = double.parse(latLng[1]);
    return LatLng(lat, lng);
  }

  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  //factory crear una nueva instancia de ScanModel
  factory ScanModel.fromMap(Map<String, dynamic> json) => new ScanModel(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "value": value == null ? null : value,
      };
}
