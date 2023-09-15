import 'package:pondrop/api/submission_api.dart';
import 'package:uuid/uuid.dart';

class FakeStoreVisit {
  static StoreVisitDto fakeVist() {
    return StoreVisitDto(
      id: const Uuid().v4(),
      storeId: const Uuid().v4(),
      userId: const Uuid().v4(),
      latitude: 0,
      longitude: 0
    );
  }
}
