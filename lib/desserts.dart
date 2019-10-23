import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pizzadelivaryapp/cart.dart';
import 'package:flutter_pizzadelivaryapp/favorites.dart';

class Dessert extends StatefulWidget {
  Dessert({Key key}) : super(key: key);

  var userdata;

  @override
  _DessertState createState() => _DessertState();
}

class _DessertState extends State<Dessert> {
  void _showAlert(String text) {
    if (text.isEmpty) return;

    AlertDialog dialog = new AlertDialog(
      content: new Text(
        text,
        style: TextStyle(
          fontSize: 15.0,
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              //moveToLogin();
              Navigator.pop(context);
            },
            child: new Text('Cancel'))
      ],
    );

    showDialog(context: context, barrierDismissible: false, child: dialog);
  }

  String _errmsg = "";
  String url = "https://pizzahuttest.herokuapp.com/api/desserts";
  String selected_size = null;
  String selected = null;
  String size_selected = null;

  bool _isFavorited = false;
  bool _isFavorite = false;
  bool _isFavourite = false;

  List<DropdownMenuItem<String>> values = [];

  loadDrop() {
    values.add(new DropdownMenuItem(
      child: new Text('1/2Kg'),
      value: '1/2Kg',
    ));
    values.add(new DropdownMenuItem(
      child: new Text('1Kg'),
      value: '1Kg',
    ));
    values.add(new DropdownMenuItem(
      child: new Text('2Kg'),
      value: '2Kg',
    ));
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else
        _isFavorited = true;
    });
  }

  void _toggleFavorit() {
    setState(() {
      if (_isFavorite) {
        _isFavorite = false;
      } else
        _isFavorite = true;
    });
  }

  void _toggleFavourit() {
    setState(() {
      if (_isFavourite) {
        _isFavourite = false;
      } else
        _isFavourite = true;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getApi();
    loadDrop();
  }

  var data;

  Future getApi() async {
    http.Response response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      var x = json.decode(response.body);
      data = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: new Card(
              elevation: 10,
              child: new Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              new Row(
              children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new Image.network(
                        data[index]['src'],

                        height: 120,
                        width: 120,
                        // color: Colors.transparent,
                      ),
//                      Positioned(
//                        top: 0.0,
//                        left: 0.0,
//                        child: IconButton(
//                          icon: (_isFavorited
//                              ? Icon(Icons.favorite)
//                              : Icon(Icons.favorite_border)),
//                          color: Colors.red[500],
//                          onPressed: () {
//                            if (_isFavorited == false) {
//                              Navigator.of(context).push(new MaterialPageRoute(
//                                  builder: (BuildContext context) {
//                                return new Favorites(
//                                  data: data[index],
//                                  userdata: widget.userdata,
//                                );
//                              }));
//                            }
//                            _toggleFavorite();
//                          },
//                        ),
//                      ),
                      Positioned(
                        bottom: 0,
                        left: 5,
                        child: new Image.network(
                          data[index]['type'],

                          height: 20,
                          width: 20,
                          // color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  new Flexible(
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new Text(
                              data[index]['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            new Text(
                              '₹${data[index]['price']}',
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        new Text(
                          data[index]['description'],
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.black, height: 1.5),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new DropdownButton<String>(
                    items: values,
                    value: size_selected,
                    hint: Text('customize'),
                    onChanged: (String value) {
                      size_selected = value;
                      setState(() {
//                                  print(size_selected);
//                                  size_selected;
                      });
                    },
                  ),
                  new RaisedButton(
                    onPressed: () {
                      if (size_selected != null) {
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return new Cart(
                                    data: data[index],
                                    size: size_selected,
                                  );
                                }));
                      } else {
                        setState(() {
                          _errmsg = "please select size";
                          _showAlert(_errmsg);
                        });
                      }
                    },
                    child: new Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  )
                ],
              ),
                ],
              ),
            ),
          );
        });
  }
}
