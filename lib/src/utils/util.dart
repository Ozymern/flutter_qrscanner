import 'package:flutter/material.dart';
import 'package:flutter_qrscanner/src/models/scans_model.dart';
import 'package:url_launcher/url_launcher.dart';

launchScan(ScanModel scanModel, BuildContext context) async {
  if (scanModel.type == 'http') {
    final url = scanModel.value;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } else {
    // context maneja todo el arbol de widget y sabe cual es el tema entre otras cosas
    Navigator.pushNamed(context, 'coordinates', arguments: scanModel);
  }
}
