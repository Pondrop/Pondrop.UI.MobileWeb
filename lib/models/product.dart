import 'package:pondrop/models/models.dart';

class Product extends FocusItem {
  const Product({
    required String id,
    required String name,
    required this.barcode,
  }) : super(id: id, name: name);

  final String barcode;

  @override
  List<Object> get props => [
        id,
        name,
        barcode,
      ];
}
