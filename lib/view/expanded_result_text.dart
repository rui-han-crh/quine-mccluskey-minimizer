import 'package:flutter/cupertino.dart';

class ExpandedResultText extends StatefulWidget {
  final String _result;
  const ExpandedResultText({super.key, required result}) : _result = result;

  @override
  State<StatefulWidget> createState() => _ExpandedResultText();
}

class _ExpandedResultText extends State<ExpandedResultText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  int fadeMilliseconds = 350;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: fadeMilliseconds),
    );

    _anim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reset();
    _controller.forward();
    return Expanded(
      child: FadeTransition(
        opacity: _anim,
        child: Center(
          child: Text(
            widget._result,
            style: const TextStyle(fontSize: 20, height: 1.5),
          ),
        ),
      ),
    );
  }
}
