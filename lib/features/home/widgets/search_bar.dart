import 'package:flutter/material.dart';

class PetSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const PetSearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search pets by name...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
