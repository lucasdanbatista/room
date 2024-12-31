import 'package:room_annotation/room_annotation.dart';

///Represents a column of a [Entity]
class Column {
  ///Specifies the first version when the given column was created
  final int since;

  const Column({
    this.since = 1,
  });
}
