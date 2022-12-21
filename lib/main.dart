import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/view/simplification_page.dart';
import 'package:proof_map/view/expression_input_tabs.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Quine-McCluskey');
    setWindowMinSize(const Size(800, 650));
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          highlightColor: Colors.white,
          backgroundColor: const Color.fromARGB(31, 143, 143, 143),
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        themeMode: ThemeMode.system,
        //home: const TestUtil());
        home: SimplicationPage(_model));
  }
}
