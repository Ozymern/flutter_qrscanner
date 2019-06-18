import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qrscanner/src/bloc/scan_bloc.dart';
import 'package:flutter_qrscanner/src/models/scans_model.dart';
import 'package:flutter_qrscanner/src/utils/util.dart' as util;
import 'package:qrcode_reader/qrcode_reader.dart';

import 'direction_page.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      body: _loadPage(_currentPage),
      bottomNavigationBar: _createBottomNavigationBar(),
      //cambio la posicion  floatingActionButton
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //agrego color principal de la aplicacion
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),

        child: Icon(Icons.center_focus_weak),
      ),
    );
  }

  //metoddo para leer QR con la camar
  _scanQR(BuildContext context) async {
    //geo:-33.55012314316467,-70.62573566874391
    // https://www.udemy.com
    String futureString = 'http://flutter.io';
    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
      print(e);
    }

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      scansBloc.insertScan(scan);
      //determino la plataforma
      if (Platform.isIOS) {
        //demoro el lanzar el lunch
        Future.delayed(
            Duration(microseconds: 750), () => util.launchScan(scan, context));
      } else {
        util.launchScan(scan, context);
      }
    }
  }

  //navegacion a las paginas
  Widget _loadPage(int _currentPage) {
    print(_currentPage);
    switch (_currentPage) {
      case 0:
        return MapPage();

      case 1:
        return DirectionPage();

      default:
        return MapPage();
    }
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
        //currentIndex elemento activo
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
              ),
              title: Text('Mapas')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.directions,
              ),
              title: Text('Direcciones'))
        ]);
  }
}
