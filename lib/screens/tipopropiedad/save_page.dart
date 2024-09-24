import 'package:flutter/material.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/models/note.dart';

class SavePage extends StatelessWidget {
  SavePage({super.key});
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Note note = ModalRoute.of(context)?.settings.arguments as Note;
    _init(note);
    return Scaffold(
        appBar: AppBar(
          title: Text("Guardar"),
          backgroundColor: Colors.blue[700],
        ),
        body: Container(
          child: _buildForm(note),
        ));
  }

  _init(Note note) {
    nombreController.text = note.nombre; // Asignar el texto al controlador
    descripcionController.text =
        note.descripcion ?? ''; // Asignar el texto, asegurando que no sea nulo
  }

  Widget _buildForm(Note note) {
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
                  labelText: "Tipo de Propiedad",
                  border: OutlineInputBorder())),
          SizedBox(
            height: 15,
          ),
          TextFormField(
              controller: descripcionController,
              maxLines: 5,
              maxLength: 500, //
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que colocar data";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Descripción", border: OutlineInputBorder())),
          ElevatedButton(
            child: Text("guardar"),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (note.id != null) {
                  //insertion
                  note.nombre = nombreController.text;
                  note.descripcion = descripcionController.text;
                  Operation.update(note);
                } else {
                  Operation.insert(Note(
                      nombre: nombreController.text,
                      descripcion: descripcionController.text));
                }
              }
            },
          )
        ]),
      ),
    );
  }
}
