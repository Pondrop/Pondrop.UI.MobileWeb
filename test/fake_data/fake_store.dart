import 'dart:math';

import 'package:pondrop/api/stores/models/models.dart';
import 'package:pondrop/models/models.dart';
import 'package:uuid/uuid.dart';

class FakeStore {
  static Store fakeStore() {
    return Store(
        id: const Uuid().v4(),
        retailer: 'Coles',
        name: 'Flutter',
        displayName: 'Coles - Flutter',
        address: '123 Street, Kingdom',
        latitude: 0,
        longitude: 0,
        communityStore: false,
        lastKnowDistanceMetres: 150);
  }

  static List<StoreDto> fakeStoreDtos({int length = 3}) {
    final rng = Random();
    final items = <StoreDto>[];

    for (var i = 0; i < length; i++) {
      items.add(StoreDto(
          searchScore: 1,
          id: const Uuid().v4(),
          name: 'Store Name ${i + 1}',
          status: 'Open',
          externalReferenceId: const Uuid().v4(),
          phone: '111-222-333-$i',
          email: 'store$i@email.com',
          openHours: '',
          retailerId: const Uuid().v4(),
          retailer: RetailerDto(name: 'Retailer Name ${rng.nextInt(5)}'),
          storeTypeId: null,
          addressLine1: '${rng.nextInt(1000)} Shop St',
          suburb: 'Suburb',
          state: 'State',
          postcode: '0000',
          country: 'AUS',
          latitude: -33.86749,
          longitude: 151.20699,
          isCommunityStore: false));
    }

    return items;
  }
}
