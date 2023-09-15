import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/shopping/models/models.dart';
import 'package:tuple/tuple.dart';

class ShoppingApi {
  ShoppingApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'shopping-list-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;

  Future<List<ShoppingListDto>> fetchLists(String accessToken) async {
    final uri = Uri.https(_baseUrl, "/ShoppingList");
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    final List items = jsonDecode(response.body);
    return items.map((e) => ShoppingListDto.fromJson(e)).toList();
  }

  Future<ShoppingListDto> createList(String accessToken, String name,
      {int sortOrder = 0}) async {
    final uri = Uri.https(_baseUrl, '/ShoppingList/create');
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      'name': name,
      'shoppingListType': ShoppingListType.grocery.name,
      'sortOrder': sortOrder
    });

    final response = await _httpClient.post(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return ShoppingListDto.fromJson(jsonDecode(response.body));
  }

  Future<bool> updateLists(
      String accessToken,
      Map<String, Tuple3<String, List<Tuple3<String, String, int>>, int>>
          idToNameStoreSortOrder) async {
    final uri = Uri.https(_baseUrl, '/ShoppingList/update');
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      "shoppingLists": idToNameStoreSortOrder.entries
          .map((e) => {
                'id': e.key,
                'name': e.value.item1,
                'stores': e.value.item2
                    .map((e) => {
                          'storeId': e.item1,
                          'storeTitle': e.item2,
                          'sortOrder': e.item3,
                        })
                    .toList(),
                'sortOrder': e.value.item3,
              })
          .toList()
    });

    final response = await _httpClient.put(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return true;
  }

  Future<bool> deleteList(
      String accessToken, String shoppingListId, String sharedShopperId) async {
    final uri = Uri.https(_baseUrl, '/SharedListShopper/remove');
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      'shoppingListId': shoppingListId,
      'sharedListShopperIds': [sharedShopperId]
    });

    final response =
        await _httpClient.delete(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return true;
  }

  Future<List<ListItemDto>> fetchItems(
      String accessToken, String listId) async {
    final uri = Uri.https(_baseUrl, '/ListItem/byshoppinglistid/$listId');
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    final List items = jsonDecode(response.body);
    return items.map((e) => ListItemDto.fromJson(e)).toList();
  }

  Future<ListItemDto> createListItem(
      String accessToken, String listId, String name, String categoryId,
      {int sortOrder = 0}) async {
    final uri = Uri.https(_baseUrl, '/ListItem/create');
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      'listItems': [
        {
          'itemTitle': name,
          'selectedCategoryId': categoryId,
          'quantity': 0,
          'itemNetSize': 0,
          'itemUOM': '',
          'selectedPreferenceIds': const [],
          'selectedProductId': null,
          'storeId': null,
          'sortOrder': sortOrder,
          'checked': false,
        }
      ],
      'shoppingListId': listId,
    });

    final response = await _httpClient.post(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    final List items = jsonDecode(response.body);
    return items.map((e) => ListItemDto.fromJson(e)).toList().first;
  }

  Future<bool> updateListItems(String accessToken, String listId,
      Map<String, Tuple3<String?, bool, int>> idToStoreCheckedSortOrder) async {
    final uri = Uri.https(_baseUrl, '/ListItem/update');
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      'listItems': idToStoreCheckedSortOrder.entries
          .map((e) => {
                'id': e.key,
                'storeId': e.value.item1,
                'checked': e.value.item2,
                'sortOrder': e.value.item3,
              })
          .toList(),
      'shoppingListId': listId,
    });

    final response = await _httpClient.put(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return true;
  }

  Future<bool> deleteListItem(
      String accessToken, String listId, String listItemId) async {
    final uri = Uri.https(_baseUrl, '/ListItem/remove');
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      'listItemIds': [
        listItemId,
      ],
      'shoppingListId': listId,
    });

    final response =
        await _httpClient.delete(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return true;
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
}
