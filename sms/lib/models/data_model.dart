import 'package:hive/hive.dart';

part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel{
  @HiveField(0)
  final String ? name;
  @HiveField(1)
  final String ? phone;

  DataModel({this.name, this.phone});

}