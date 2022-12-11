import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/view/simplication_page.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Quine-McCluskey');
    setWindowMinSize(const Size(600, 966));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Model _model = Model(Parser());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage(_model));
  }
}
