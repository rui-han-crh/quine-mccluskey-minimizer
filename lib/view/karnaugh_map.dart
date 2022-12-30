import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:proof_map/extensions/boolean_extension.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/utils/pair.dart';
import 'package:proof_map/view/utils/grey_code.dart';

const double cellSize = 45;

class KarnaughMap extends StatefulWidget {
  final Iterable<LiteralTerm> variableOrder;
  final Iterable<Implicant> essentialPrimeImplicants;
  late final Map<int, List<Pair<int, Implicant>>> termToEpiMap;
  final bool transpose;

  KarnaughMap({
    Key? key,
    required this.variableOrder,
    required this.essentialPrimeImplicants,
    this.transpose = true,
  }) : super(key: key) {
    // Creates the map from minterm index to the implicants that cover it
    termToEpiMap = {};
    int runningIndex = 0;
    for (Implicant epi in essentialPrimeImplicants) {
      for (int mintermIndex in epi.coveredMintermIndices) {
        termToEpiMap[mintermIndex] ??= [];
        termToEpiMap[mintermIndex]!.add(Pair(runningIndex, epi));
      }
      runningIndex++;
    }
  }

  @override
  State<KarnaughMap> createState() => KarnaughMapState();
}

class KarnaughMapState extends State<KarnaughMap> {
  List<Widget> rowWiseGreyCodeChildren = [];
  List<Widget> columnWiseGreyCodeChildren = [];
  int xBits = 0; // for the horizontally oriented grey code
  int yBits = 0; // for the vertically oriented grey code
  int width = 0; // assign later
  int height = 0; // assign later

  List<Color> colors = [
    Colors.red,
    Colors.lightGreen,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.lime,
    Colors.indigo,
    Colors.brown,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.amber,
    Colors.grey
  ];

  @override
  void initState() {
    super.initState();
    int numberOfVariables = widget.variableOrder.length;
    yBits = numberOfVariables >> 1;
    xBits = numberOfVariables - yBits;

    width = 1 << xBits;
    height = 1 << yBits;

    rowWiseGreyCodeChildren = generateGreyCode(xBits)
        .map(
          (e) => Container(
            alignment: Alignment.center,
            width: cellSize,
            child: Text(e),
          ),
        )
        .toList();

    columnWiseGreyCodeChildren = generateGreyCode(yBits)
        .map(
          (e) => RotatedBox(
            quarterTurns: 3,
            child: Container(
              alignment: Alignment.center,
              width: cellSize,
              child: Text(e),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> tableRows = [];

    for (int y = 0; y < height; y++) {
      List<TableCell> tableCells = [];
      for (int x = 0; x < width; x++) {
        int greyCode = toGreyCode(y) << xBits | toGreyCode(x);

        List<Widget> borders = [];

        if (widget.termToEpiMap.containsKey(greyCode)) {
          for (Pair<int, Implicant> pair in widget.termToEpiMap[greyCode]!) {
            int leftX = (x - 1 + width) % width;
            int rightX = (x + 1) % width;
            int topY = (y - 1 + height) % height;
            int bottomY = (y + 1) % height;

            int leftGreyCode = toGreyCode(y) << xBits | toGreyCode(leftX);
            int rightGreyCode = toGreyCode(y) << xBits | toGreyCode(rightX);
            int topGreyCode = toGreyCode(topY) << xBits | toGreyCode(x);
            int bottomGreyCode = toGreyCode(bottomY) << xBits | toGreyCode(x);

            double borderWidth = 4;
            double borderPadding = math.min(0.5 + 3 * pair.item1, 18.5);
            Color color = colors[pair.item1 % colors.length];

            int hasLeftBorder =
                (!pair.item2.coveredMintermIndices.contains(leftGreyCode))
                    .toInt();
            int hasRightBorder =
                (!pair.item2.coveredMintermIndices.contains(rightGreyCode))
                    .toInt();
            int hasTopBorder =
                (!pair.item2.coveredMintermIndices.contains(topGreyCode))
                    .toInt();
            int hasBottomBorder =
                (!pair.item2.coveredMintermIndices.contains(bottomGreyCode))
                    .toInt();

            borders.add(
              Padding(
                padding: EdgeInsets.only(
                  left: hasLeftBorder * borderPadding,
                  top: hasTopBorder * borderPadding,
                  right: hasRightBorder * borderPadding,
                  bottom: hasBottomBorder * borderPadding,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: cellSize -
                      (hasTopBorder + hasBottomBorder) * borderPadding,
                  width: cellSize -
                      (hasLeftBorder + hasRightBorder) * borderPadding,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          width: hasLeftBorder * borderWidth, color: color),
                      top: BorderSide(
                          width: hasTopBorder * borderWidth, color: color),
                      right: BorderSide(
                          width: hasRightBorder * borderWidth, color: color),
                      bottom: BorderSide(
                          width: hasBottomBorder * borderWidth, color: color),
                    ),
                  ),
                ),
              ),
            );
          }
        }

        Widget cell = Stack(
          alignment: Alignment.center,
          children: borders +
              [
                Container(
                  alignment: Alignment.center,
                  height: cellSize,
                  width: cellSize,
                  child: Text(
                      widget.termToEpiMap.containsKey(greyCode) ? "1" : "0"),
                ),
              ],
        );

        tableCells.add(TableCell(child: cell));
      }
      tableRows.add(TableRow(children: tableCells));
    }
    return Stack(
      children: [
        CustomPaint(
          painter: DiagonalLinePainter(
            color: Colors.white,
            strokeWidth: 2.0,
          ),
          child: const SizedBox.square(
            dimension: cellSize * 0.85,
          ),
        ),
        Positioned(
          top: -5,
          left: 15,
          child: Text(widget.variableOrder.skip(yBits).join(" ")),
        ),
        Positioned(
          left: -5,
          top: 15,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              widget.variableOrder.take(yBits).join(" "),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(children: columnWiseGreyCodeChildren),
              const SizedBox(width: 3),
              Column(
                children: [
                  Row(
                    children: rowWiseGreyCodeChildren,
                  ),
                  Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    border: TableBorder.all(
                        color: Theme.of(context).colorScheme.outline, width: 1),
                    children: tableRows,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DiagonalLinePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(DiagonalLinePainter oldDelegate) => false;
}
