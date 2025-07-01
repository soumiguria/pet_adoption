import 'package:flutter/material.dart';

class AdoptedPetsNotifier extends ValueNotifier<Set<String>> {
  AdoptedPetsNotifier() : super(<String>{});
}

final adoptedPetsNotifier = AdoptedPetsNotifier();
