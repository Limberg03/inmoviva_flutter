import 'package:flutter/material.dart';
import 'package:inmoviva/db/operation.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});
  @override
  Widget build(BuildContext context) {
    Operation.notes();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/save');
            }),
        appBar: AppBar(
          title: Text("Listado"),
          backgroundColor: Colors.blue[700],
        ),
        body: Container(
            child: ListView(children: <Widget>[
          ListTile(
            title: Text("Nota 1"),
          ),
          ListTile(
            title: Text("Nota 2"),
          ),
          ListTile(
            title: Text("Nota 3"),
          ),
          ListTile(
            title: Text("Nota 4"),
          ),
          ListTile(
            title: Text("Nota 5"),
          ),
          ListTile(
            title: Text("Nota 6"),
          ),
          ListTile(
            title: Text("Nota 7"),
          ),
        ])));
  }
}
