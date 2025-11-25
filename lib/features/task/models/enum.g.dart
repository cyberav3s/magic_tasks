import 'package:hive/hive.dart';
import 'package:magic_tasks/features/task/models/enum.dart';

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = 1;

  @override
  Tag read(BinaryReader reader) {
    final index = reader.readByte();
    return Tag.values[index];
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer.writeByte(obj.index);
  }
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 2;

  @override
  Status read(BinaryReader reader) {
    final index = reader.readByte();
    return Status.values[index];
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    writer.writeByte(obj.index);
  }
}
