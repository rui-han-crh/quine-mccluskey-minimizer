import 'package:flutter/widgets.dart';

abstract class ExpressionTextField extends StatefulWidget {
  const ExpressionTextField({super.key});

  @override
  State<ExpressionTextField> createState();

  String get text;
}
