import 'package:geolocator/geolocator.dart';
import 'package:pondrop/api/stores/store_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

class StoreRepository {
  StoreRepository({required UserRepository userRepository, StoreApi? storeApi})
      : _userRepository = userRepository,
        _storeApi = storeApi ?? StoreApi();

  final UserRepository _userRepository;
  final StoreApi _storeApi;

  Future<Tuple2<List<Store>, bool>> fetchStores(
      String keyword, int skip, Position? sortByPosition,
      {int top = 0}) async {
    return _fetchStores(keyword, skip, top, sortByPosition, false);
  }

  Future<Tuple2<List<Store>, bool>> fetchCommunityStores(
      String keyword, int skip, Position? sortByPosition,
      {int top = 0}) async {
    return _fetchStores(keyword, skip, top, sortByPosition, true);
  }

  Future<Tuple2<List<Store>, bool>> _fetchStores(String keyword, int skip,
      int top, Position? sortByPosition, bool communityStores) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = communityStores
          ? await _storeApi.searchCommunityStores(user!.accessToken,
              keyword: keyword,
              skip: skip,
              top: top,
              sortByPosition: sortByPosition)
          : await _storeApi.searchStores(user!.accessToken,
              keyword: keyword,
              skipIdx: skip,
              top: top,
              sortByPosition: sortByPosition);

      final stores = searchResult.value
          .map((e) => Store(
              id: e.id,
              retailer: e.retailer?.name ?? '',
              name: e.name,
              displayName: e.retailer?.name?.isNotEmpty == true
                  ? '${e.retailer!.name} ${e.name}'
                  : e.name,
              address:
                  '${e.addressLine1}, ${e.suburb}, ${e.state}, ${e.postcode}',
              latitude: e.latitude,
              longitude: e.longitude,
              communityStore: e.isCommunityStore,
              lastKnowDistanceMetres: e.distanceInMeters(sortByPosition)))
          .toList();

      return Tuple2(stores, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }
}
