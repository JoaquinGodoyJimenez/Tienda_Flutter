import 'package:dio/dio.dart';
import '../models/categoria_model.dart';

class CategoriaApi {
  final dio = Dio();
  
  Future<List<CategoriaModel>?> getCategorias() async {
    try {
      final response = await dio.get('https://mrjc-tienda.000webhostapp.com/ws/categoria_ws.php');
      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;
        return jsonData.map((categoria) => CategoriaModel.fromJson(categoria)).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }
}