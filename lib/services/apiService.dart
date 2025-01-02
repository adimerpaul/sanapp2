import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String? baseUrl = dotenv.env['API_BACK'];

  Future getCarouselsPage() async {
    final response = await http.get(Uri.parse('$baseUrl/carouselsPage'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load carouselsPage');
    }
  }
  Future getCarouselsMini() async {
    final response = await http.get(Uri.parse('$baseUrl/carouselsMini'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load carouselsMini');
    }
  }
  Future getProducts(String searchQuery) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_BACK']}/productos?search=$searchQuery'),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load products');
    }
  }
  Future getSucursales() async {
    final response = await http.get(Uri.parse('$baseUrl/sucursales'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sucursales');
    }
  }
  Future productosId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/productos/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load productosId');
    }
  }

}