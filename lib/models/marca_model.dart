class MarcaModel {
  String? idMarca;
  String? marca;
  String? proveedor;

  MarcaModel({this.idMarca, this.marca, this.proveedor});

  factory MarcaModel.fromJson(Map<String, dynamic> json) {
    return MarcaModel(
      idMarca: json['id_marca'],
      marca: json['marca'],
      proveedor: json['proveedor'],
    );
  }
}
