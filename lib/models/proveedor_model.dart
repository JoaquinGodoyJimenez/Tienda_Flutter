class ProveedorModel {
  String? idProveedor;
  String? proveedor;
  String? telefono;

  ProveedorModel({this.idProveedor, this.proveedor, this.telefono});

  factory ProveedorModel.fromJson(Map<String, dynamic> json) {
    return ProveedorModel(
      idProveedor: json['id_proveedor'],
      proveedor: json['proveedor'],
      telefono: json['telefono'],
    );
  }
}
