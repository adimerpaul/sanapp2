import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart' as globals;

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {

  String? url = dotenv.env['API_BACK'];
  void _incrementQuantity(int index) {
    setState(() {
      globals.carritoCompras[index]['cantidad']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (globals.carritoCompras[index]['cantidad'] > 1) {
        globals.carritoCompras[index]['cantidad']--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      globals.carritoCompras.removeAt(index);
    });
  }

  void _sendOrderToWhatsApp() {
    if (globals.carritoCompras.isEmpty) return;

    String message = "Hola, deseo comprar los siguientes productos:%0A";
    double total = 0;

    for (var product in globals.carritoCompras) {
      var cantidad = int.parse(product['cantidad'].toString());
      message += "- ${product['nombre']} x$cantidad a Bs.${product['precio']} c/u%0A";
      total += cantidad * double.parse(product['precio'].toString());
    }

    message += "%0ATotal: Bs.${total.toStringAsFixed(2)}";
    String url = 'https://api.whatsapp.com/send?phone=59172319869&text=$message';
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de compras')),
      body: globals.carritoCompras.isEmpty
          ? const Center(child: Text('Tu carrito está vacío.'))
          : ListView.builder(
        itemCount: globals.carritoCompras.length,
        itemBuilder: (context, index) {
          var product = globals.carritoCompras[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                // '$url/../images/${productDetails!['imagen']}',
                '$url/../images/${product['imagen']}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product['nombre']),
              subtitle: Text('Bs.${product['precio']} x ${product['cantidad']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _decrementQuantity(index),
                  ),
                  Text('${product['cantidad']}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _incrementQuantity(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton.icon(
          onPressed: _sendOrderToWhatsApp,
          icon: const Icon(Icons.send, size: 18, color: Colors.white),
          label: const Text('Enviar pedido por WhatsApp'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
