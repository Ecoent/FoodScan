import 'package:flutter/material.dart';
import 'package:food_scan/styles/customText.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerHome extends Drawer {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Quentin SAUVETRE"),
            accountEmail: new Text("apps@quentin-sauvetre.fr"),
            currentAccountPicture: CircleAvatar(
              child: Image.asset('lib/images/logoFoodScan.png')//FlutterLogo(),
              //backgroundColor: Colors.blue,
            ),
            otherAccountsPictures: <Widget>[
              new CustomText(
                "v0.1",
                factor: 1.1,
              ),
            ],
          ),
          new Column(
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.help),
                title: Text("A propos de l'application"),
                onTap: () {
                  //
                },
              ),
              Divider(
                height: 1.0,
              ),
              ListTile(
                leading: new Icon(Icons.mail),
                title: Text('Contactez moi'),
                onTap: () {
                  _launchMail();
                },
              ),
              Divider(
                height: 1.0,
              ),
              ListTile(
                leading: new Icon(Icons.input),
                title: Text('Visitez mon site web'),
                onTap: () {
                  _launchWebsite();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _launchMail() async {
    await launch(
        'mailto:apps@quentin-sauvetre.fr?subject=Information&body=Hi Quentin,\n\n');
  }

  _launchWebsite() async {
    const url = 'https://quentin-sauvetre.fr';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}