import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:san2/pages/carrito.dart';
import '../services/apiService.dart';
import 'detail_screen.dart';
import '../globals.dart' as globals;

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final List<String> imgList = [];
  final List<String> imgListMini = [];
  final List<dynamic> productList = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    getCarouselsPage();
    fetchProducts();
  }

  Future<void> getCarouselsPage() async {
    final carousels = await ApiService().getCarouselsPage();
    final carouselsMini = await ApiService().getCarouselsMini();
    final url = dotenv.env['API_BACK'];

    imgListMini.clear();
    for (final c in carouselsMini) {
      imgListMini.add('$url/../images/${c['image']}');
    }

    imgList.clear();
    for (final c in carousels) {
      imgList.add('$url/../images/${c['image']}');
    }

    // 🔐 importante: evita que _bannerIndex apunte a un índice fuera de rango
    setState(() {
      _bannerIndex = (imgList.isEmpty) ? 0 : (_bannerIndex % imgList.length);
    });
  }

  Future<void> fetchProducts({String searchQuery = ''}) async {
    setState(() {
      isLoading = true;
    });
    try {
      var products = await ApiService().getProducts(searchQuery);
      // print(jsonEncode(products));
      // print('searchQuery: $searchQuery');
      productList.clear();
      var url = dotenv.env['API_BACK'];
      for (var product in products) {
        if (product['porcentaje'] > 0) {
          product['es_porcentaje'] = true;
          product['precioNormal'] = product['precio'];
          var precio = product['precio'] - (product['precio'] * product['porcentaje'] / 100);
          product['precio'] = precio.toStringAsFixed(2);
        }
        productList.add({
          'id': product['id'],
          'name': product['nombre'],
          'description': product['descripcion'],
          'precio': product['precio'],
          'image': '$url/../images/${product['imagen']}',
          'precioNormal': product['precioNormal'],
        });
      }
      setState(() {});
    } catch (error) {
      print("Error fetching products: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 18, right: 10),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 280,
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        fetchProducts(searchQuery: value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 40,
                          color: Colors.grey,
                        ),
                        hintText: 'Buscar..',
                        hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarritoPage()
                        ),
                      );
                      setState(() {});
                    },
                    child: Badge(
                      label: Text(globals.carritoCompras.length.toString()),
                      child: Image(
                        height: 30,
                        width: 30,
                        image: AssetImage('assets/icons/img.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 160,
                child: imgList.isEmpty
                // 🧱 Placeholder mientras carga (evita RangeError)
                    ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
                    : Stack(
                  children: [
                    CarouselSlider.builder(
                      itemCount: imgList.length,
                      options: CarouselOptions(
                        height: 160,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 700),
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() => _bannerIndex = index);
                        },
                      ),
                      itemBuilder: (context, index, realIdx) {
                        final item = imgList[index]; // ✅ seguro porque no entra si está vacío
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1F000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item,
                              fit: BoxFit.cover,
                              loadingBuilder: (c, w, p) =>
                              p == null ? w : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black12),
                            ),
                          ),
                        );
                      },
                    ),

                    // Indicador solo si hay elementos
                    if (imgList.length > 0)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_bannerIndex + 1}/${imgList.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text(
                  //   'Ver más',
                  //   style: TextStyle(
                  //     fontSize: 17,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xff2A977D),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : productList.isEmpty
                  ? const Text('No se encontraron productos')
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 productos por fila
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7, // Ajusta la relación entre ancho y alto
                ),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            product: product,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            product['image'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product['description'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      '\Bs${product['precioNormal']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2A977D),
                                        fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '\Bs${product['precio']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                // Text(
                                //   '\Bs${product['price']}',
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.red,
                                //     fontSize: 14,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
