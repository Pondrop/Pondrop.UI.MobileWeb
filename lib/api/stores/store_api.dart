import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/stores/models/store_dto.dart';

class StoreApi {
  StoreApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'store-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;

  Future<StoreSearchResultDto> searchStores(
    String accessToken, {
    String keyword = '',
    int skipIdx = 0,
    int top = 0,
    Position? sortByPosition,
  }) {
    return _searchStores(accessToken,
        keyword: keyword,
        skip: skipIdx,
        top: top,
        sortByPosition: sortByPosition,
        communityStores: false);
  }

  Future<StoreSearchResultDto> searchCommunityStores(
    String accessToken, {
    String keyword = '',
    int skip = 0,
    int top = 0,
    Position? sortByPosition,
  }) {
    return _searchStores(accessToken,
        keyword: keyword,
        skip: skip,
        top: top,
        sortByPosition: sortByPosition,
        communityStores: true);
  }

  Future<StoreSearchResultDto> _searchStores(
    String accessToken, {
    String keyword = '',
    int skip = 0,
    int top = 0,
    Position? sortByPosition,
    bool communityStores = false,
  }) async {
    final queryParams = {
      'search': keyword.isEmpty ? '*' : keyword,
      '\$filter': 'isCommunityStore eq $communityStores',
      '\$skip': '$skip',
      '\$orderby': sortByPosition != null
          ? 'geo.distance(locationSort, geography\'POINT(${sortByPosition.longitude} ${sortByPosition.latitude})\') asc'
          : '\$orderby=retailer,name asc&'
    };

    if (top > 0) {
      queryParams['\$top'] = '$top';
    }

    final uri = Uri.https(_baseUrl, "/Store/search", queryParams);
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    return StoreSearchResultDto.fromJson(jsonDecode(response.body));
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }
}
