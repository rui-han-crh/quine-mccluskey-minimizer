import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/view/foldout.dart';
import 'package:proof_map/view/implicant_table.dart';
import 'package:proof_map/view/karnaugh_map.dart';

class SolutionSlide extends StatefulWidget {
  final Answer answer;
  final bool generateKMap;
  final bool? mintermsStartAsFolded;
  final bool? maxtermsStartAsFolded;
  final void Function(bool)? onFoldMintermsTable;
  final void Function(bool)? onFoldMaxtermsTable;
  const SolutionSlide(
      {this.answer = const Answer.empty(),
      required this.generateKMap,
      this.mintermsStartAsFolded,
      this.maxtermsStartAsFolded,
      this.onFoldMintermsTable,
      this.onFoldMaxtermsTable,
      Key? key})
      : super(key: key);

  @override
  State<SolutionSlide> createState() => _SolutionSlideState();
}

class _SolutionSlideState extends State<SolutionSlide> {
  late Answer answer = widget.answer;

  @override
  Widget build(BuildContext context) {
    Iterable<Iterable<String>> mintermTableValues = answer.mintermTableValues();
    Iterable<Iterable<String>> maxtermTableValues = answer.maxtermTableValues();
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Solution",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            ExpressionAnswerTable(answer: answer),
            const SizedBox(height: 20),
            FoldOutWithTerm(
              title: "Minterms Table",
              answer: answer,
              mintermTableValues: mintermTableValues,
              essentialPrimeImplicants:
                  answer.getMintermEssentialPrimeImplicants(),
              onColumnChange: onColumnsChange,
              generateKMap: widget.generateKMap,
              startAsFolded: widget.mintermsStartAsFolded ?? false,
              onFold: widget.onFoldMintermsTable,
            ),
            const SizedBox(height: 10),
            FoldOutWithTerm(
              title: "Maxterms Table",
              answer: answer,
              mintermTableValues: maxtermTableValues,
              essentialPrimeImplicants:
                  answer.getMaxtermEssentialPrimeImplicants(),
              onColumnChange: onColumnsChange,
              generateKMap: widget.generateKMap,
              startAsFolded: widget.maxtermsStartAsFolded ?? false,
              onFold: widget.onFoldMaxtermsTable,
            ),
          ],
        ),
      ),
    );
  }

  void onColumnsChange(List<String> newColumnHeaders) {
    setState(() {
      answer = answer.withHeaders(newColumnHeaders);
    });
  }
}

class FoldOutWithTerm extends StatelessWidget {
  const FoldOutWithTerm({
    Key? key,
    required this.title,
    required this.answer,
    required this.mintermTableValues,
    required this.essentialPrimeImplicants,
    required this.onColumnChange,
    required this.generateKMap,
    this.startAsFolded = true,
    this.onFold,
  }) : super(key: key);

  final String title;
  final Answer answer;
  final Iterable<Iterable<String>> mintermTableValues;
  final Iterable<Implicant> essentialPrimeImplicants;
  final Function(List<String>) onColumnChange;
  final bool generateKMap;
  final bool startAsFolded;
  final void Function(bool)? onFold;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      ImplicantTable(
        key: ValueKey(answer),
        tableHeaders: answer.headers,
        tableValues: mintermTableValues,
        onColumnsChange: onColumnChange,
      ),
    ];

    if (generateKMap) {
      children.add(const SizedBox(width: 80));
      children.add(KarnaughMap(
        variableOrder: answer.headers,
        essentialPrimeImplicants: essentialPrimeImplicants,
      ));
    }

    return FoldOut(
      title: title,
      duration: const Duration(milliseconds: 100),
      startAsFolded: startAsFolded,
      onFold: onFold,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                },
              ),
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpressionAnswerTable extends StatelessWidget {
  const ExpressionAnswerTable({
    Key? key,
    required this.answer,
  }) : super(key: key);

  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
          color: Theme.of(context).colorScheme.outline, width: 1),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth()
      },
      children: [
        // First Row
        TableRow(
          children: [
            const TableCell(
              child: ExpressionResultTextContainer("Simplified Expression"),
            ),
            TableCell(
              child: ExpressionResultTextContainer(answer.simplestForm),
            ),
          ],
        ),
        // Second row
        TableRow(
          children: [
            const TableCell(
              child: ExpressionResultTextContainer("Disjunctive Normal Form"),
            ),
            TableCell(
              child: ExpressionResultTextContainer(
                  answer.disjunctiveNormalFormString),
            ),
          ],
        ),
        // Third row
        TableRow(
          children: [
            const TableCell(
              child: ExpressionResultTextContainer("Conjunctive Normal Form"),
            ),
            TableCell(
              child: ExpressionResultTextContainer(
                  answer.conjuctiveNormalFormString),
            ),
          ],
        ),
      ],
    );
  }
}

class ExpressionResultTextContainer extends StatelessWidget {
  final String text;
  const ExpressionResultTextContainer(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
