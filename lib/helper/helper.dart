import 'package:expenses_tracker_app/main.dart';
import 'package:flutter/material.dart';

Widget searchBar(void Function(String value) filter) {
    return TextField(
      onChanged: (value) => filter(value),
      decoration:InputDecoration(
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: kColorScheme.background,
        hintText: 'Tìm kiếm',
        hintStyle: const  TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      ),
    );
}