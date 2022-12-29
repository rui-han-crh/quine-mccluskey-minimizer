import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/view/expression_text_fields/algebraic_expression_textfield.dart';
import 'package:proof_map/view/expression_text_fields/maxterms_expression_textfield.dart';
import 'package:proof_map/view/expression_text_fields/minterms_expression_textfield.dart.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class ExpressionInputTabs extends StatefulWidget {
  final Model _model;
  const ExpressionInputTabs(this._model, {super.key});

  @override
  State<StatefulWidget> createState() => _ExpressionInputTabs();
}

class _ExpressionInputTabs extends State<ExpressionInputTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget._model.expressionForm.index,
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: TabBar(
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          overlayColor: MaterialStateProperty.all(Colors.deepOrange.shade900),
          onTap: onChangeTab,
          tabs: const [
            Tab(
              child: TabText("Algebraic"),
            ),
            Tab(
              child: TabText("Minterms"),
            ),
            Tab(
              child: TabText("Maxterms"),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            AlgebraicExpressionTextField(model: widget._model),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MintermsExpressionTextfield(
                model: widget._model,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaxtermsExpressionTextfield(
                model: widget._model,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChangeTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        widget._model.expressionForm = ExpressionForm.algebraic;
        break;
      case 1:
        widget._model.expressionForm = ExpressionForm.minterms;
        log(widget._model.expressionForm.toString());
        break;
      case 2:
        widget._model.expressionForm = ExpressionForm.maxterms;
        break;
    }
  }
}

class TabText extends StatelessWidget {
  final String _string;
  const TabText(this._string, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        _string,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
