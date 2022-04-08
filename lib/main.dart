import 'package:flutter/material.dart';

import 'dart_game.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DartGame(),
    );
  }
}
