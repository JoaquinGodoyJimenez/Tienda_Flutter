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

  Future<void> deleteCategoria(int id) async {
    try {
      final url = 'https://mrjc-tienda.000webhostapp.com/ws/categoria_ws.php?id=$id';
      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        print('Categoría eliminada con éxito');
      } else {
        print('Error al eliminar la categoría. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al eliminar la categoría: $e');
    }
  }
}