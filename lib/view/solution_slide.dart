import 'package:flutter/material.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/view/foldout.dart';
import 'package:proof_map/view/implicant_table.dart';

class SolutionSlide extends StatelessWidget {
  final Answer answer;
  const SolutionSlide({this.answer = const Answer.empty(), Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Table(
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
                      child: ExpressionResultTextContainer(
                          "Simplified Expression"),
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
                      child: ExpressionResultTextContainer(
                          "Disjunctive Normal Form"),
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
                      child: ExpressionResultTextContainer(
                          "Conjunctive Normal Form"),
                    ),
                    TableCell(
                      child: ExpressionResultTextContainer(
                          answer.conjuctiveNormalFormString),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            FoldOut(
              title: "Minterms Table",
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: EdgeInsets.all(10),
                child: ImplicantTable(
                  tableHeaders: answer.headers.map((e) => e.postulate),
                  tableValues: answer.mintermTableValues(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FoldOut(
              title: "Maxterms Table",
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: EdgeInsets.all(10),
                child: ImplicantTable(
                  tableHeaders: answer.headers.map((e) => e.postulate),
                  tableValues: answer.maxtermTableValues(),
                ),
              ),
            ),
          ],
        ),
      ),
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
