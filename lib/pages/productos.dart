import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/apiService.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final List<String> imgList = [];
  final List<dynamic> productList = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCarouselsPage();
    fetchProducts();
  }

  Future<void> getCarouselsPage() async {
    var carousels = await ApiService().getCarouselsPage();
    var url = dotenv.env['API_BACK'];
    imgList.clear();
    for (var carousel in carousels) {
      imgList.add('$url/../images/${carousel['image']}');
    }
    setState(() {});
  }

  Future<void> fetchProducts({String searchQuery = ''}) async {
    setState(() {
      isLoading = true;
    });
    try {
      var products = await ApiService().getProducts(searchQuery);
      print(jsonEncode(products));
      print('searchQuery: $searchQuery');
      productList.clear();
      var url = dotenv.env['API_BACK'];
      for (var product in products) {
        productList.add({
          'name': product['nombre'],
          'description': product['descripcion'],
          'price': product['precio'],
          'image': '$url/../images/${product['imagen']}',
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
                  const Badge(
                    label: Text('1'),
                    child: Image(
                      height: 30,
                      width: 30,
                      image: AssetImage('assets/icons/img.png'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(height: 90.0, autoPlay: true),
              items: imgList
                  .map((item) => Container(
                child: Center(
                  child: Image.network(item, fit: BoxFit.cover, width: 1000),
                ),
              ))
                  .toList(),
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
                  Text(
                    'Ver más',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A977D),
                    ),
                  ),
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
                  return Container(
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
                              Text(
                                '\Bs${product['price']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2A977D),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
