import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class StaticContactModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10), // Eliminar el padding interior del AlertDialog
      titlePadding: EdgeInsets.fromLTRB(5, 5, 5, 5), // Eliminar el padding interior del título
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 130), // Espacio para separar el logo del título
              Image.asset('assets/logo-upc.png', height: 30),
               // Asegúrate de tener un logo en assets
            ],
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal
            },
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
            Container(
              decoration: BoxDecoration(
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 5.0,bottom: 0.0),
              child: Text(
                'Autores',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nombre: Dino Iván',style: TextStyle(fontSize: 11.9),),
              subtitle: Text('Edad: 29\nCarrera: Ingeniería de Software',style: TextStyle(fontSize: 11.9),),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nombre: Antonio José',style: TextStyle(fontSize: 11.9),),
              subtitle: Text('Edad: 22\nCarrera: Ingeniería de Software',style: TextStyle(fontSize: 11.9),),
            ),
          ],
        ),
      ),
    );
  }
}