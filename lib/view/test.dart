import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rerderable List',
      theme: ThemeData(
        dividerColor: const Color(0x50000000),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Reorderable List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  android,
}

class _MyHomePageState extends State<MyHomePage> {
  late List<ItemData> _items;
  _MyHomePageState() {
    _items = [];
    for (int i = 0; i < 5; ++i) {
      String label = "List item $i";
      _items.add(ItemData(label, ValueKey(i)));
    }
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.android;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableList(
        onReorder: _reorderCallback,
        onReorderDone: _reorderDone,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          // cacheExtent: 3000,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Item(
                      data: _items[index],
                      // first and last attributes affect border drawn during dragging
                      isFirst: index == 0,
                      isLast: index == _items.length - 1,
                      draggingMode: _draggingMode,
                    );
                  },
                  childCount: _items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
  }) : super(key: key);

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = const BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          child: Opacity(
        // hide content for placeholder
        opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              Text(data.title, style: Theme.of(context).textTheme.subtitle1),
              // Triggers the reordering
            ],
          ),
        ),
      )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
