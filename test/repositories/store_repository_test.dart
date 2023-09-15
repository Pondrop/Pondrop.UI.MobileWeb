import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/store_api.dart';
import 'package:pondrop/api/stores/models/models.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../fake_data/fake_data.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockStoreApi extends Mock implements StoreApi {}

void main() {
  final User user = User(email: 'me@email.com', accessToken: const Uuid().v4());

  late UserRepository userRepository;
  late StoreApi storeApi;

  bool testStoreDtoMapping(List<Store> objects, List<StoreDto> dtos) {
    if (objects.length != dtos.length) {
      return false;
    }

    for (var i = 0; i < objects.length; i++) {
      final dto = dtos[i];
      final obj = objects[i];

      final displayName = dto.retailer?.name?.isNotEmpty == true
          ? '${dto.retailer!.name} ${dto.name}'
          : dto.name;
      final addr =
          '${dto.addressLine1}, ${dto.suburb}, ${dto.state}, ${dto.postcode}';

      if (dto.id != obj.id ||
          dto.retailer?.name != obj.retailer ||
          dto.name != obj.name ||
          displayName != obj.displayName ||
          addr != obj.address ||
          dto.latitude != obj.latitude ||
          dto.longitude != obj.longitude) {
        return false;
      }
    }

    return true;
  }

  setUp(() {
    userRepository = MockUserRepository();
    storeApi = MockStoreApi();

    when(() => userRepository.getUser())
        .thenAnswer((invocation) => Future<User?>.value(user));
  });

  group('StoreRepository', () {
    test('Construct an instance', () {
      expect(
          StoreRepository(userRepository: userRepository, storeApi: storeApi),
          isA<StoreRepository>());
    });
  });

  group('StoreRepository Stores', () {
    test('Get stores from API', () async {
      const query = 'search term';
      final dtos = FakeStore.fakeStoreDtos();

      when(() => storeApi.searchStores(user.accessToken,
              keyword: query, skipIdx: 0))
          .thenAnswer((invocation) => Future.value(StoreSearchResultDto(
              value: dtos, odataNextLink: '', odataContext: '')));

      final repo =
          StoreRepository(userRepository: userRepository, storeApi: storeApi);

      final result = await repo.fetchStores(query, 0, null);

      assert(testStoreDtoMapping(result.item1, dtos) == true);
      expect(result.item2, false);
    });

    test('Get stores from API (more results)', () async {
      const query = 'search term';
      final dtos = FakeStore.fakeStoreDtos(length: 20);

      when(() => storeApi.searchStores(user.accessToken,
              keyword: query, skipIdx: 0))
          .thenAnswer((invocation) => Future.value(StoreSearchResultDto(
              value: dtos, odataNextLink: 'another page', odataContext: '')));

      final repo =
          StoreRepository(userRepository: userRepository, storeApi: storeApi);

      final result = await repo.fetchStores(query, 0, null);

      assert(testStoreDtoMapping(result.item1, dtos) == true);
      expect(result.item2, true);
    });
  });
}
