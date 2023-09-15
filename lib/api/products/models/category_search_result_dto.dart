part of 'category_dto.dart';

class CategorySearchResultDto {
  CategorySearchResultDto({
    required this.odataContext,
    required this.value,
    required this.odataNextLink});

  late final String odataContext;
  late final List<CategoryDto> value;
  late final String odataNextLink;
  
  CategorySearchResultDto.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'] ?? '';
    odataNextLink = json['@odata.nextLink'] ?? '';
    
    value = <CategoryDto>[];
    if (json['value'] != null) {
      json['value'].forEach((v) {
        value.add(CategoryDto.fromJson(v));
      });
    }    
  }
}