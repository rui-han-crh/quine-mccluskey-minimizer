import 'package:flutter/material.dart';

class FoldOut extends StatefulWidget {
  final String title;
  final Widget child;
  final Duration duration;

  const FoldOut({
    Key? key,
    required this.title,
    required this.child,
    required this.duration,
  }) : super(key: key);

  @override
  State<FoldOut> createState() => _FoldOutState();
}

class _FoldOutState extends State<FoldOut> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  bool isFolded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                overlayColor:
                    const MaterialStatePropertyAll(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                padding: const MaterialStatePropertyAll(EdgeInsets.all(16.0)),
                textStyle: MaterialStatePropertyAll(
                    Theme.of(context).textTheme.bodyText1),
                minimumSize:
                    const MaterialStatePropertyAll(Size.fromHeight(25)),
              ),
              onPressed: onFold,
              child: Row(
                children: [
                  Icon(isFolded ? Icons.arrow_right : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.outline),
                  Text(widget.title),
                ],
              ),
            ),
          ],
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: widget.child,
          ),
        ),
      ],
    );
  }

  void onFold() {
    setState(() {
      if (isFolded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      isFolded = !isFolded;
    });
  }
}
