import 'package:collection/collection.dart';
import 'package:pondrop/api/shopping_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

class ShoppingRepository {
  ShoppingRepository(
      {required UserRepository userRepository, ShoppingApi? shoppingApi})
      : _userRepository = userRepository,
        _shoppingApi = shoppingApi ?? ShoppingApi();

  final UserRepository _userRepository;
  final ShoppingApi _shoppingApi;

  Future<List<ShoppingList>> fetchLists() async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final result = await _shoppingApi.fetchLists(user!.accessToken);

      final lists = result
          .where(
              (e) => e.sharedListShoppers.any((sls) => sls.userId == user.id))
          .sorted((e1, e2) => e1.sortOrder.compareTo(e2.sortOrder))
          .map((e) => ShoppingList(
                id: e.id,
                shopperId: e.sharedListShoppers
                    .where((e) => e.userId == user.id)
                    .first
                    .id,
                name: e.name,
                itemCount: e.listItemIds.length,
                stores: e.stores
                    .sorted((e1, e2) => e1.sortOrder.compareTo(e2.sortOrder))
                    .map((e) => ShoppingListStore(
                        storeId: e.storeId,
                        name: e.name,
                        sortOrder: e.sortOrder))
                    .toList(),
                sortOrder: 0,
              ))
          .toList();

      return lists;
    }

    return const [];
  }

  Future<ShoppingList?> createList(String name, int sortOrder) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final result = await _shoppingApi.createList(user!.accessToken, name,
          sortOrder: sortOrder);

      if (result.sharedListShoppers.any((e) => e.userId == user.id)) {
        final list = ShoppingList(
          id: result.id,
          shopperId: result.sharedListShoppers
              .where((e) => e.userId == user.id)
              .first
              .id,
          name: result.name,
          itemCount: result.listItemIds.length,
          stores: const [],
          sortOrder: 0,
        );

        return list;
      }
    }

    return null;
  }

  Future<bool> deleteList(String listId, String sharedShopperId) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true &&
        listId.isNotEmpty &&
        sharedShopperId.isNotEmpty) {
      return await _shoppingApi.deleteList(
          user!.accessToken, sharedShopperId, sharedShopperId);
    }

    return false;
  }

  Future<bool> updateLists(List<ShoppingList> lists) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final updateMap =
          <String, Tuple3<String, List<Tuple3<String, String, int>>, int>>{};

      for (final i in lists) {
        updateMap[i.id] = Tuple3(
            i.name,
            i.stores
                .map((e) => Tuple3(e.storeId, e.name, e.sortOrder))
                .toList(),
            i.sortOrder);
      }

      return await _shoppingApi.updateLists(user!.accessToken, updateMap);
    }

    return false;
  }

  Future<List<ShoppingListItem>> fetchListItems(String listId) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true && listId.isNotEmpty) {
      final result = await _shoppingApi.fetchItems(user!.accessToken, listId);

      final lists = result
          .sorted((e1, e2) => e1.sortOrder.compareTo(e2.sortOrder))
          .map((e) => ShoppingListItem(
                id: e.id,
                listId: listId,
                categoryId: e.categoryId,
                name: e.name,
                storeId: e.storeId,
                checked: e.checked,
                sortOrder: e.sortOrder,
              ))
          .toList();

      return lists;
    }

    return const [];
  }

  Future<ShoppingListItem?> addItemToList(
      String listId, String categoryId, String name, int sortOrder) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true &&
        listId.isNotEmpty &&
        categoryId.isNotEmpty) {
      final result = await _shoppingApi.createListItem(
          user!.accessToken, listId, name, categoryId,
          sortOrder: sortOrder);

      final list = ShoppingListItem(
        id: result.id,
        listId: listId,
        categoryId: result.categoryId,
        name: result.name,
        storeId: result.storeId,
        checked: result.checked,
        sortOrder: result.sortOrder,
      );

      return list;
    }

    return null;
  }

  Future<bool> deleteListItem(String listId, String itemId) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true &&
        listId.isNotEmpty &&
        itemId.isNotEmpty) {
      return await _shoppingApi.deleteListItem(
          user!.accessToken, listId, itemId);
    }

    return false;
  }

  Future<bool> updateListItems(
      String listId, List<ShoppingListItem> items) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true && listId.isNotEmpty) {
      final updateMap = <String, Tuple3<String?, bool, int>>{};

      for (final i in items) {
        updateMap[i.id] = Tuple3(i.storeId, i.checked, i.sortOrder);
      }

      return await _shoppingApi.updateListItems(
          user!.accessToken, listId, updateMap);
    }

    return false;
  }
}
