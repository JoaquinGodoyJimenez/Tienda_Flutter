class CategoriaModel {
  String? idCategoria;
  String? categoria;

  CategoriaModel({this.idCategoria, this.categoria});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      idCategoria: json['id_categoria'],
      categoria: json['categoria'],
    );
  }
}
