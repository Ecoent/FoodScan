import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:food_scan/styles/customText.dart';
import 'package:food_scan/styles/customBoxDecoration.dart';
///import 'package:cached_network_image/cached_network_image.dart';


class Url {
  final String url;

  Url(this.url);
}

class Article extends StatefulWidget {
  Article({Key key, @required this.url}) : super(key: key);
  final String url;

  @override
  _ArticleState createState() => new _ArticleState(url); //or URL !
}

class _ArticleState extends State<Article> {
  String url;
  Map data;
  bool isData = false;
  String nutriScorePath = "";
  String nutriScoreData = "";
  _ArticleState(this.url);
  bool debug = false;

  String energy = null, fat = null, saturatedFat = null, carbohydrates = null, sugars = null, dietaryFiber = null, proteins = null, salt = null;

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  Future<void> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = json.decode(response.body);
    });

    if (data["status"] == 0) {
      //product not found
      Navigator.pop(context, false);
    }
    else {
      isData = true;
      if ( data["product"]["nutrition_grades"]!=null) {
        nutriScoreData = data["product"]["nutrition_grades"].toUpperCase();
        // NUSTRISCORE IMAGE
        if (nutriScoreData == 'A') { nutriScorePath = "lib/images/nutriscore-a.png"; }
        else if (nutriScoreData == 'B') { nutriScorePath = "lib/nutriscore-b.png"; }
        else if (nutriScoreData == 'C') { nutriScorePath = "lib/nutriscore-c.png"; }
        else if (nutriScoreData == 'D') { nutriScorePath = "lib/nutriscore-d.png"; }
        else if (nutriScoreData == 'E') { nutriScorePath = "lib/nutriscore-e.png"; }
      }
      else {
        nutriScorePath = null;
      }
      // check data number or string
      if (data["product"]["nutriments"]["energy_value"]!=null || data["product"]["nutriments"]["energy_value"].isFinite) {
        energy = data["product"]["nutriments"]["energy_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["energy"]!=null || data["product"]["nutriments"]["energy"].isFinite) {
          energy = data["product"]["nutriments"]["energy_100g"].toString();
        }
      }
      if (data["product"]["nutriments"]["fat_value"]!=null || data["product"]["nutriments"]["fat_value"].isFinite) {
        fat = data["product"]["nutriments"]["fat_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["fat"]!=null || data["product"]["nutriments"]["fat"].isFinite) {
          fat = data["product"]["nutriments"]["fat"].toString();
        }
      }
      if (data["product"]["nutriments"]["saturated-fat_value"]!=null || data["product"]["nutriments"]["saturated-fat_value"].isFinite) {
        saturatedFat = data["product"]["nutriments"]["saturated-fat"].toString();
      }
      else {
        if (data["product"]["nutriments"]["saturated-fat"]!=null || data["product"]["nutriments"]["saturated-fat"].isFinite) {
          saturatedFat = data["product"]["nutriments"]["saturated-fat_100g"].toString();
        }

      }
      if (data["product"]["nutriments"]["carbohydrates_value"]!=null || data["product"]["nutriments"]["carbohydrates_value"].isFinite) {
        carbohydrates = data["product"]["nutriments"]["carbohydrates_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["carbohydrates"]!=null || data["product"]["nutriments"]["carbohydrates"].isFinite) {
          carbohydrates = data["product"]["nutriments"]["carbohydrates_100g"].toString();
        }
      }
      if (data["product"]["nutriments"]["sugars_value"]!=null || data["product"]["nutriments"]["sugars_value"].isFinite) {
        sugars = data["product"]["nutriments"]["sugars_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["sugars"]!=null || data["product"]["nutriments"]["sugars"].isFinite) {
          sugars = data["product"]["nutriments"]["sugars_100g"].toString();
        }
      }
      if (data["product"]["nutriments"]["fiber_value"]!=null || data["product"]["nutriments"]["fiber_value"].isFinite) {
        dietaryFiber = data["product"]["nutriments"]["fiber_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["fiber"]!=null || data["product"]["nutriments"]["fiber"].isFinite) {
          dietaryFiber = data["product"]["nutriments"]["fiber_100g"].toString();
        }
      }
      if (data["product"]["nutriments"]["proteins_value"]!=null || data["product"]["nutriments"]["proteins_value"].isFinite) {
        proteins = data["product"]["nutriments"]["proteins_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["proteins_100g"]!=null || data["product"]["nutriments"]["proteins_100g"].isFinite) {
          proteins = data["product"]["nutriments"]["proteins_100g"].toString();
        }
      }
      if (data["product"]["nutriments"]["salt_value"]!=null || data["product"]["nutriments"]["salt_value"].isFinite) {
        salt = data["product"]["nutriments"]["salt_value"].toString();
      }
      else {
        if (data["product"]["nutriments"]["salt"]!=null || data["product"]["nutriments"]["salt"].isFinite) {
          salt = data["product"]["nutriments"]["salt"].toString();
        }
      }
    }
  }

  //@override
  Widget myUI() {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () { Navigator.pop(context); },
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'RÉSUMÉ'),
                Tab(text: 'TABLEAU NUTRITIONNEL'),
                Tab(text: 'INFORMATIONS'),
              ],
            ),
            title: Text('Article Details'),
          ),
          body: TabBarView(
            children: [
              ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: <Widget>[
                    Container(
                      decoration: debug ? new CustomBoxDecoration() : null,
                      child:
                      /*new CachedNetworkImage(
                        imageUrl: "http://via.placeholder.com/350x150",
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                      ),*/
                      new Image.network(data["product"]["image_front_url"], height: 100, width: 100,),
                      alignment: Alignment.center,
                    ),
                    Container(height: 15.0,),
                    nutriScorePath!=null ? Container(
                      decoration: debug ? new CustomBoxDecoration() : null,
                      alignment: Alignment.center,
                      height: 80.0,
                      child: new Image.asset(nutriScorePath),
                    ) : Container(),
                    Container(height: 25.0,),
                    Container(
                      decoration: debug ? new CustomBoxDecoration() : null,
                      child: Card(
                        elevation: 5.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            data["product"]["product_name"]!=null ? new Padding(padding: EdgeInsets.only(top: 8.0, left: 8.0,), child: CustomText(data["product"]["product_name"], factor: 1.5,),) : Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("no title")),
                            data["product"]["generic_name_fr"]!=null ? new Padding(padding: EdgeInsets.only(left: 8.0,), child: CustomText(data["product"]["generic_name_fr"], color: Colors.grey,),) : Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("no description")),
                            Divider(height: 20.0,),
                            Container(height: 10.0,),
                            data["code"]!=null ? Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("Code EAN: " + data["code"]),) : Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("Code EAN: null")),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: CustomText(" "),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
              ListView(
                  children: <Widget>[
                    Container(
                        decoration: debug ? new CustomBoxDecoration() : null,
                        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            nutriScorePath != null ? Container(
                              decoration: debug ? new CustomBoxDecoration() : null,
                              alignment: Alignment.center,
                              height: 80.0,
                              child: new Image.asset(nutriScorePath),
                            ): Container(),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Informations nutritionnelles"),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                Container(
                                  child: Text("Pour 100g"),
                                  width: MediaQuery.of(context).size.width/3,
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),
                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Energie",),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                energy!=null ? Container(child: Text(energy + ' kcal',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? kcal',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),
                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Graisse",  style: TextStyle(fontWeight: FontWeight.bold)),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                fat!=null ? Container(child: Text(fat + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),

                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Gras saturée"),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                saturatedFat!=null ? Container(child: Text(saturatedFat + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),

                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Glucides"),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                carbohydrates!=null ? Container(child: Text(carbohydrates + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),
                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child:  Text("Sucres", style: TextStyle(fontWeight: FontWeight.bold)),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                sugars != null ? Container(child: Text(sugars + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),

                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child:   Text("Fibres"),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                dietaryFiber!=null ? Container(child: Text(dietaryFiber + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),

                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Protéines"),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                proteins!=null ? Container(child: Text(proteins + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),

                            Divider(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: debug ? new CustomBoxDecoration() : null,
                                  child: Text("Sel", style: TextStyle(fontWeight: FontWeight.bold)),
                                  width: MediaQuery.of(context).size.width/3,
                                ),
                                salt!=null ? Container(child: Text(salt + ' g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,) : Container(child: Text('? g',), width: MediaQuery.of(context).size.width/3, alignment: Alignment.centerRight,),
                              ],
                            ),
                            Divider(height: 20.0,),
                          ],
                        )
                    ),
                  ]
              ),

              ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Card(
                      elevation: 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 8.0,),
                            child: CustomText("Liste des ingrédients:", factor: 1.3,),
                          ),
                          Divider(height: 20.0,),
                          Container(height: 10.0,),
                          data["product"]["ingredients_text_fr"]!=null ? Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText(data["product"]["ingredients_text_fr"],)) : Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("null",)),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 8.0,),
                            child: CustomText("Allergènes:", factor: 1.3,),
                          ),
                          Divider(height: 20.0,),
                          Container(height: 10.0,),
                          data["product"]["allergens"]!=null ? Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText(data["product"]["allergens"]),) : Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("null"),),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 8.0,),
                            child: CustomText("Emballage:", factor: 1.3,),
                          ),
                          Divider(height: 20.0,),
                          Container(height: 10.0,),
                          data["product"]["packaging"]!=null ? Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText(data["product"]["packaging"]),) :Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: CustomText("null"),)
                        ],
                      ),
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: !isData ? new Center(child: new CircularProgressIndicator(),) : myUI(),
      ),
    );
  }

  Future<Null> alert() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: new Column(
              children: <Widget>[
                new Text(
                  "Error",
                  textScaleFactor: 1.5,
                ),
                new Text("Votre code n'est pas (encore) présent dans la base de données. Veuillez cliquez ici pour l'ajouter et y contribuer."),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text(
                  'Exit',
                  style: new TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
            ],
          );
        });
  }
}
