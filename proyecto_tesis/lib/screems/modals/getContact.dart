import 'package:flutter/material.dart';
import 'package:proyecto_tesis/main.dart';

class GetContactModal extends StatefulWidget {
  final Map<String, dynamic> contact;

  GetContactModal({required this.contact});

  @override
  _GetContactModalState createState() => _GetContactModalState();
}

class _GetContactModalState extends State<GetContactModal> {
  late TextEditingController _fullnameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _relationshipController;

  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fullnameController = TextEditingController(text: widget.contact['fullname']);
    _phoneNumberController = TextEditingController(text: widget.contact['phonenumber']);
    _relationshipController = TextEditingController(text: widget.contact['relationship']);
  }

  Future<void> _loadToken() async{
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Contacto de emergencia',style: TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.bold),),
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
            TextFormField(
              controller: _fullnameController,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0,-10.0, 0, 10),),
              style: TextStyle(fontSize: 14.0),
            ),
            TextFormField(
              controller: _phoneNumberController,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Número de teléfono',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0,0, 0, 10)),
              style: TextStyle(fontSize: 14.0),
            ),
            TextFormField(
              controller: _relationshipController,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Relación',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0,0, 0, 10)),
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneNumberController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }
}