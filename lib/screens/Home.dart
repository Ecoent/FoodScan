import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_scan/styles/customText.dart';
import 'package:food_scan/styles/customBoxDecoration.dart';
import 'package:food_scan/screens/ArticleDetail.dart';
import 'package:food_scan/widgets/drawerHome.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "";
  bool debug = false;
  bool connected = false;

  initState() {
    super.initState();
    this.verifyConnectivity();
  }

  Future<void> verifyConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
       connected = true;
     }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new Article(url : 'https://world.openfoodfacts.org/api/v0/product/'+result+'.json');
            })
        );
      });
    }
    on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) { setState(() { result = "Camera permission was denied"; }); }
      else { setState(() { result = "Unknown Error $ex"; }); }
    }
    on FormatException { setState(() { result = "You pressed the back button before scanning anything"; }); }
    catch (ex) { setState(() { result = "Unknown Error $ex"; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Scan"),
      ),
      drawer: new DrawerHome(),
      body: new Center(
        child: new ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  CustomText("Bienvenue !", factor: 2.0,),
                  new Container(
                    alignment: Alignment.center,
                    decoration: debug ? new CustomBoxDecoration() : null,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Merci à",),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child: Text("OpenFoodFacts", style: TextStyle(decoration: TextDecoration.underline),),
                          onPressed: _launchOpenFoodFacts,
                        ),
                        Text(" pour leur base de données libre  "),
                        Image.asset('lib/images/openFoodFactsLogo.png', scale: 5.0,),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    decoration: debug ? new CustomBoxDecoration() : null,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text("Avertissement: la base de données peut être incomplète ou erronnée, elle est maintenue par OpenFoodFacts ainsi que ses utilisateurs.\nVous pouvez aussi y contribuer en corrigeant ou en ajoutant des produits !"),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    decoration: debug ? new CustomBoxDecoration() : null,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text("L'application nécessite d'être connectée au réseau pour fonctionner.\nDans une future version un contrôle sera effectué."),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed:  _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _launchOpenFoodFacts() async {
    const url = 'https://world.openfoodfacts.org';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
