import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    fetchProductDetails(widget.product['id']);
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
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
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
                        // const Badge(
                        //   label: Text('1'),
                        //   child: Icon(Icons.shopping_bag_outlined, size: 30),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 15),
              Image.network(
                '$url/../images/${productDetails!['imagen']}',
                height: 350,
                width: 350,
                fit: BoxFit.cover,
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
              const SizedBox(height: 14),
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
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A977D),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Text(
                  //   'Reviews',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
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
              const Divider(color: Colors.black),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Marca:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          productDetails!['marca'] ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     const Text(
                    //       'Color:',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 7),
                    //     Text(
                    //       'N/A', // Puedes reemplazar con un campo relevante si existe
                    //       style: const TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                            var url = 'https://api.whatsapp.com/send/?phone=59172319869&text=Deseo+comprar+1+${productDetails!['nombre']}+a+Bs.${productDetails!['precio']}+c%2Fu.+Total+Bs.${productDetails!['precio']}';
                            launchUrl(url);
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
            ],
                    ),
                  ),
          ),
    );
  }
}
