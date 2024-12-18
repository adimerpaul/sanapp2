import 'package:flutter/material.dart';

class Sucursales extends StatefulWidget {
  const Sucursales({super.key});

  @override
  State<Sucursales> createState() => _SucursalesState();
}

class _SucursalesState extends State<Sucursales> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ListTile(
          title: Text('Sucursal 1'),
        ),
        ListTile(
          title: Text('Sucursal 2'),
        ),
        ListTile(
          title: Text('Sucursal 3'),
        ),
      ],
    );
  }
}
