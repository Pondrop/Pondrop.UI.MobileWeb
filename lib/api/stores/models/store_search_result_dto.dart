part of 'store_dto.dart';

class StoreSearchResultDto {
  StoreSearchResultDto({
    required this.odataContext,
    required this.value,
    required this.odataNextLink});

  late final String odataContext;
  late final List<StoreDto> value;
  late final String odataNextLink;
  
  StoreSearchResultDto.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'] ?? '';
    odataNextLink = json['@odata.nextLink'] ?? '';
    
    value = <StoreDto>[];
    if (json['value'] != null) {
      json['value'].forEach((v) {
        value.add(StoreDto.fromJson(v));
      });
    }    
  }
}