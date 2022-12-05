import 'package:equatable/equatable.dart';

class Pair<T, U> with EquatableMixin {
  T item1;
  U item2;

  Pair(this.item1, this.item2);

  @override
  List<Object?> get props => [item1, item2];
}
