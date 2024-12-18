import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:san2/services/apiService.dart';
import 'package:url_launcher/url_launcher.dart';

class Sucursales extends StatefulWidget {
  const Sucursales({super.key});

  @override
  State<Sucursales> createState() => _SucursalesState();
}

class _SucursalesState extends State<Sucursales> {
  List sucursales = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    getSucursales();
  }

  Future<void> getSucursales() async {
    try {
      var getsucursales = await ApiService().getSucursales();
      setState(() {
        sucursales = getsucursales;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching sucursales: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator()) // Muestra indicador de carga
        : sucursales.isEmpty
        ? const Center(child: Text('No se encontraron sucursales'))
        : ListView.builder(
      itemCount: sucursales.length,
      itemBuilder: (context, index) {
        final sucursal = sucursales[index];
        return ListTile(
          title: Text(sucursal['nombre']),
          subtitle: Text(sucursal['direccion']),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            var latitud = double.tryParse(sucursal['latitud'] ?? '');
            var longitud = double.tryParse(sucursal['longitud'] ?? '');
            if (latitud != null && longitud != null) {
              var url =
                  'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                print('No se pudo abrir el enlace: $url');
              }
            } else {
              print('Latitud o longitud inválida');
            }
          },
        );
      },
    );
  }
}
