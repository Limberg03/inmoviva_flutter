import 'package:flutter/material.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/models/note.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guardar"),
          backgroundColor: Colors.blue[700],
        ),
        body: Container(
          child: _FormSave(),
        ));
  }
}

class _FormSave extends StatelessWidget {
  // const _FormSave({super.key});
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
              controller: nombreController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colcoar data";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "titulo", border: OutlineInputBorder())),
          SizedBox(
            height: 15,
          ),
          TextFormField(
              controller: descripcionController,
              maxLines: 5,
              maxLength: 50, //
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colcoar data";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "contenido", border: OutlineInputBorder())),
          ElevatedButton(
            child: Text("guardar"),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                print("valido: " + nombreController.text);

                Operation.insert(Note(id:1,nombre: nombreController.text, descripcion: descripcionController.text));

              }
            },
          )
        ]),
      ),
    );
  }
}
