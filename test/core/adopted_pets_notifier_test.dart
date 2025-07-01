import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adoption_app/core/notifiers/adopted_pets_notifier.dart';

void main() {
  group('AdoptedPetsNotifier', () {
    test('initial value is empty set', () {
      final notifier = AdoptedPetsNotifier();
      expect(notifier.value, <String>{});
    });

    test('adding an adopted pet id notifies listeners', () {
      final notifier = AdoptedPetsNotifier();
      int notifyCount = 0;
      notifier.addListener(() {
        notifyCount++;
      });
      notifier.value = {'pet1'};
      expect(notifier.value, {'pet1'});
      expect(notifyCount, 1);
    });

    test('adding multiple ids works', () {
      final notifier = AdoptedPetsNotifier();
      notifier.value = {'pet1'};
      notifier.value = {...notifier.value, 'pet2'};
      expect(notifier.value, {'pet1', 'pet2'});
    });
  });
}
