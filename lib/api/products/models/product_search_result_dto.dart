part of 'product_dto.dart';

class ProductSearchResultDto {
  ProductSearchResultDto(
      {required this.odataContext,
      required this.value,
      required this.odataNextLink});

  late final String odataContext;
  late final List<ProductDto> value;
  late final String odataNextLink;

  ProductSearchResultDto.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'] ?? '';
    odataNextLink = json['@odata.nextLink'] ?? '';

    value = <ProductDto>[];
    if (json['value'] != null) {
      json['value'].forEach((v) {
        value.add(ProductDto.fromJson(v));
      });
    }
  }
}
