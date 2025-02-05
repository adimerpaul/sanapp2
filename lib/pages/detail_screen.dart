import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:san2/addons/snackbarHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart' as globals;

import '../services/apiService.dart';

class DetailPage extends StatefulWidget {
  final Map product;

  const DetailPage({
    super.key,
    required this.product,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool favoriteClick = false;
  String? url = dotenv.env['API_BACK'];
  Map? productDetails;
  List? agencias;

  @override
  void initState() {
    super.initState();
    fetchProductDetails(widget.product['id']);
    getAgencias();
  }
  String Textlower(String text) {
    var texto = text.toLowerCase();
    var first = texto[0].toUpperCase();
    return first + texto.substring(1);
  }

  Future<void> getAgencias() async {
    try {
      var agencias = await ApiService().getSucursales();
      setState(() {
        this.agencias = agencias;
      });
      // for (var agencia in agencias) {
      //   print("Agencia: $agencia");
      // }
    } catch (error) {
      print("Error fetching agencias: $error");
    } finally {
      setState(() {});
    }
  }

  Future<void> fetchProductDetails(int id) async {
    try {
      var product = await ApiService().productosId(id);
      if (product['porcentaje'] > 0) {
        product['es_porcentaje'] = true;
        product['precioNormal'] = product['precio'];
        var precio = product['precio'] - (product['precio'] * product['porcentaje'] / 100);
        product['precio'] = precio.toStringAsFixed(2);
      }
      print("Product details: $product");
      setState(() {
        productDetails = product;
      });
    } catch (error) {
      print("Error fetching product details: $error");
    } finally {
      setState(() {});
    }
  }
  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('No se pudo abrir el enlace: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: productDetails == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
            child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            favoriteClick ? Icons.favorite : Icons.favorite_border,
                            color: favoriteClick ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              favoriteClick = !favoriteClick;
                            });
                          },
                        ),
                        const SizedBox(width: 13),
                        // const Icon(Icons.share, size: 30),
                        IconButton(
                            onPressed: () {
                              var url = 'https://api.whatsapp.com/send/?phone=59172319869&text=Deseo+comprar+1+${productDetails!['nombre']}+a+Bs.${productDetails!['precio']}+c%2Fu.+Total+Bs.${productDetails!['precio']}';
                              launchUrl(url);
                            },
                            icon: const Icon(Icons.share, size: 30)
                        ),
                        const SizedBox(width: 13),
                        Badge(
                          label: Text( globals.carritoCompras.length.toString(), style: const TextStyle(color: Colors.white)),
                          child: Icon(Icons.shopping_bag_outlined, size: 30),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 15),
              Center(
                child: Image.network(
                  '$url/../images/${productDetails!['imagen']}',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                productDetails!['nombre'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: const [
              //     Icon(Icons.star, color: Colors.orange),
              //     Text(
              //       '4.9 Ratings',
              //       style: TextStyle(
              //         color: Colors.grey,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 15,
              //       ),
              //     ),
              //     Text('-', style: TextStyle(fontSize: 30)),
              //     Text(
              //       '2.3k+ Reviews ',
              //       style: TextStyle(
              //         color: Colors.grey,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 15,
              //       ),
              //     ),
              //     Text('-', style: TextStyle(fontSize: 30)),
              //     Text(
              //       '2.9k+ Sold',
              //       style: TextStyle(
              //         color: Colors.grey,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 15,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    'Descripcion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A977D),
                    ),
                  ),
                  // {
                  //   id: 32,
                  //   nombre: "ARTEZINE 20 MG X COMPRIMIDO",
                  //   barra: null,
                  //   cantidad: 110,
                  //   cantidadAlmacen: 0,
                  //   cantidadSucursal1: 38,
                  //   cantidadSucursal2: 16,
                  //   cantidadSucursal3: 8,
                  //   cantidadSucursal4: 13,
                  //   costo: 27.69,
                  //   precioAntes: null,
                  //   precio: 36,
                  //   porcentaje: 8,
                  //   activo: "ACTIVO",
                  //   unidad: "TABLETAS",
                  //   registroSanitario: "NN - 45450/2022",
                  //   paisOrigen: "BOLIVIA",
                  //   nombreComun: "Leflunomida 20 mg",
                  //   composicion: "Leflunomida 20 mg",
                  //   marca: "BRESCOT PHARMA",
                  //   distribuidora: "DISTRIBUIDORA COFAR S.A.",
                  //   imagen: "1704826657ARTEZINE20_E.png",
                  //   descripcion: "Inmunomodulador, antirreumático",
                  //   category_id: 3,
                  //   agencia_id: 1,
                  //   created_at: "2024-01-09T15:04:17.000000Z",
                  //   updated_at: "2025-01-24T18:49:08.000000Z",
                  //   subcategory_id: 3,
                  //   cantidadSucursal5: 0,
                  //   cantidadSucursal6: 14,
                  //   cantidadSucursal7: 21,
                  //   cantidadSucursal8: 0,
                  //   cantidadSucursal9: 0,
                  //   cantidadSucursal10: 0
                  // }
                  SizedBox(width: 20),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      productDetails!['descripcion'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              // const Divider(color: Colors.black),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDetailRow('Marca:', productDetails!['marca'] ?? 'N/A'),
                    _buildDetailRow('Registro Sanitario:', productDetails!['registroSanitario'] ?? 'N/A'),
                    _buildDetailRow('Unidada:', productDetails!['unidad'] ?? 'N/A'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: MediaQuery.of(context).size.width + 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildDetailRow('Principio activo:', productDetails!['composicion'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),
                    _buildDetailRow('Pais de origen:', productDetails!['paisOrigen'] ?? 'N/A'),
                    _buildDetailRow('Cantidad:', productDetails!['cantidad'] > 100 ? '100+' : productDetails!['cantidad'].toString()),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Precio'),
                      Row(
                        children: [
                          Text(
                            'Bs${productDetails!['precioNormal']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2A977D),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Bs${productDetails!['precio']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 70,
                        decoration: const BoxDecoration(
                          color: Color(0xff2A977D),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                            topLeft: Radius.circular(7),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // https://api.whatsapp.com/send/?phone=59172319869&text=Deseo+comprar+1+ARTINEO+B+X+CAPSULA+a+Bs.+13.14+c%2Fu.+Total+Bs.+13.14&type=phone_number&app_absent=0
                            // var url = 'https://api.whatsapp.com/send/?phone=59172319869&text=Deseo+comprar+1+${productDetails!['nombre']}+a+Bs.${productDetails!['precio']}+c%2Fu.+Total+Bs.${productDetails!['precio']}';
                            // launchUrl(url);
                            // agregar a carritoCompras
                            globals.carritoCompras.add(productDetails);
                            setState(() {});
                            successSnackBar(context, 'Producto agregado al carrito de compras');
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.shopping_basket_outlined, color: Colors.white),
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // https://api.whatsapp.com/send/?phone=59172319869&text=Deseo+comprar+1+ARTINEO+B+X+CAPSULA+a+Bs.+13.14+c%2Fu.+Total+Bs.+13.14&type=phone_number&app_absent=0
                          var url = 'https://api.whatsapp.com/send/?phone=59172319869&text=Deseo+comprar+1+${productDetails!['nombre']}+a+Bs.${productDetails!['precio']}+c%2Fu.+Total+Bs.${productDetails!['precio']}';
                          launchUrl(url);
                        },
                        child: Container(
                          height: 50,
                          width: 120,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Comprar ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Text('a Bs.${productDetails!['precio']} c/u', style: const TextStyle(color: Colors.grey)),
              // mostrar lancantidad des an cada sucursal
              const SizedBox(height: 5),
              Text('Sucursales disponibles', style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 0),
              for (var agencia in agencias!)
                if (productDetails!['cantidadSucursal${agencia['id']}'] != null && productDetails!['cantidadSucursal${agencia['id']}'] > 0)
                Column(
                  children: [
                    // Row(
                    //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(agencia['nombre'], style: const TextStyle(color: Colors.black)),
                    //     // Text(productDetails!['cantidadSucursal${agencia['id']}'] == null ? '0' : productDetails!['cantidadSucursal${agencia['id']}'].toString(), style: const TextStyle(color: Colors.black)),
                    //     GestureDetector(
                    //       onTap: () {
                    //         var latitud = agencia['latitud'];
                    //         var longitud = agencia['longitud'];
                    //         var url = 'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud';
                    //         launchUrl(url);
                    //       },
                    //       // icon dense
                    //       child: Badge(
                    //         label: Text('Disponible', style: const TextStyle(color: Colors.white)),
                    //         child: const Icon(Icons.location_on, color: Colors.black),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    ListTile(
                      title: Text(Textlower(agencia['nombre']), style: const TextStyle(color: Colors.black)),
                      // subtitle: Text('Cantidad: ${productDetails!['cantidadSucursal${agencia['id']}']}', style: const TextStyle(color: Colors.black)),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          var latitud = agencia['latitud'];
                          var longitud = agencia['longitud'];
                          var url = 'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud';
                          launchUrl(url);
                        },
                        icon: const Icon(Icons.location_on, color: Colors.white,size: 12),
                        label: const Text('Ver ubicacion', style: TextStyle(color: Colors.white, fontSize: 12)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(60, 25)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 8)),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                  ],
                ),
            ],
                    ),
                  ),
          ),
    );
  }
}
Widget _buildDetailRow(String label, String value) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      const SizedBox(width: 7),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    ],
  );
}